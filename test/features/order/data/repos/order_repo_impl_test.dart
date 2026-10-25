import 'dart:async';

import 'package:flower_app/core/base/api_response.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/api_request_params.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/order/data/data_sources/order_osrm_remote_data_source.dart';
import 'package:flower_app/features/order/data/data_sources/order_remote_data_source.dart';
import 'package:flower_app/features/order/data/data_sources/order_tracking_fcm_data_source.dart';
import 'package:flower_app/features/order/data/models/delivery_confirmation_model.dart';
import 'package:flower_app/features/order/data/models/order_model.dart';
import 'package:flower_app/features/order/data/models/order_tracking_model.dart';
import 'package:flower_app/features/order/data/models/osrm_route_model.dart';
import 'package:flower_app/features/order/data/repos/order_repo_impl.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flutter_test/flutter_test.dart';

ApiResponse<OrderTrackingModel> _ok(String status) => ApiResponse(
      status: true,
      code: 200,
      message: 'Order tracking retrieved',
      data: OrderTrackingModel(orderId: 'o1', status: status),
    );

/// Records every tracking call and answers with whatever the test scripted.
class _FakeOrderRemote implements OrderRemoteDataSource {
  int callCount = 0;

  /// When set, every call parks on this completer instead of answering.
  Completer<ApiResponse<OrderTrackingModel>>? gate;

  ApiResponse<OrderTrackingModel> Function(int callIndex) respond =
      (_) => _ok('OUT_FOR_DELIVERY');

  @override
  Future<ApiResponse<OrderTrackingModel>> orderTracking({
    required String orderId,
  }) {
    final response = respond(callCount++);
    if (gate != null) return gate!.future;
    return Future.value(response);
  }

  @override
  Future<ApiResponse<List<OrderModel>>> getAllOrders({
    int? page,
    int? pageSize,
  }) =>
      throw UnimplementedError();

  @override
  Future<ApiResponse<DeliveryConfirmationModel>> confirmDelivery({
    required String orderId,
  }) =>
      throw UnimplementedError();
}

/// Broadcasts manual change signals, the way a real push channel would.
class _FakeFcmDataSource implements OrderTrackingFcmDataSource {
  final _signals = StreamController<void>.broadcast();

  @override
  Stream<void> watchChangeSignals({required String orderId}) =>
      _signals.stream;

  void signal() => _signals.add(null);

  Future<void> close() => _signals.close();
}

class _FakeOsrmRemote implements OrderOsrmRemoteDataSource {
  OsrmRouteModel response = const OsrmRouteModel();

  @override
  Future<OsrmRouteModel> fetchRoute({
    required GeoPoint from,
    required GeoPoint to,
  }) async =>
      response;
}

void main() {
  late _FakeOrderRemote remote;
  late _FakeFcmDataSource fcm;
  late _FakeOsrmRemote osrm;
  late OrderRepoImpl repo;

  setUp(() {
    remote = _FakeOrderRemote();
    fcm = _FakeFcmDataSource();
    osrm = _FakeOsrmRemote();
    repo = OrderRepoImpl(remote, SafeCall(), fcm, osrm);
  });

  tearDown(() async => fcm.close());

  group('watchTracking', () {
    test('pulls the snapshot as soon as the page listens', () async {
      final emissions = <BaseResponse<TrackingEntity>>[];
      final sub = repo.watchTracking(orderId: 'o1').listen(emissions.add);
      await pumpEventQueue();

      expect(remote.callCount, 1);
      expect(emissions, hasLength(1));
      expect((emissions.single as SuccessResponse).data.status,
          OrderStatus.outForDelivery);
      await sub.cancel();
    });

    test('refetches immediately when a change signal arrives', () async {
      remote.respond = (index) => index == 0
          ? _ok('OUT_FOR_DELIVERY')
          : _ok('ARRIVED');
      final emissions = <OrderStatus>[];
      final sub = repo.watchTracking(orderId: 'o1').listen((response) {
        if (response case SuccessResponse(:final data)) {
          emissions.add(data.status);
        }
      });
      await pumpEventQueue();

      fcm.signal();
      await pumpEventQueue();

      expect(remote.callCount, 2);
      expect(emissions, [OrderStatus.outForDelivery, OrderStatus.arrived]);
      await sub.cancel();
    });

    test('collapses signals into one catch-up fetch after an in-flight poll',
        () async {
      final gate = Completer<ApiResponse<OrderTrackingModel>>();
      remote.gate = gate;
      final sub = repo.watchTracking(orderId: 'o1').listen((_) {});
      await pumpEventQueue();
      expect(remote.callCount, 1);

      fcm.signal();
      fcm.signal();
      fcm.signal();
      await pumpEventQueue();

      // Signals during a request never start a second one on top of it...
      expect(remote.callCount, 1);

      gate.complete(_ok('ARRIVED'));
      await pumpEventQueue();

      // ...but exactly one follow-up fetch runs once the request settles.
      expect(remote.callCount, 2);
      await sub.cancel();
    });

    test('does not re-emit an unchanged snapshot', () async {
      final emissions = <BaseResponse<TrackingEntity>>[];
      final sub = repo.watchTracking(orderId: 'o1').listen(emissions.add);
      await pumpEventQueue();

      fcm.signal();
      await pumpEventQueue();

      expect(remote.callCount, 2);
      expect(emissions, hasLength(1));
      await sub.cancel();
    });

    test('reports a failed tracking fetch as an ErrorResponse event', () async {
      remote.respond = (_) => ApiResponse(
            status: false,
            code: 500,
            message: 'Tracking unavailable',
            data: null,
          );
      final emissions = <BaseResponse<TrackingEntity>>[];
      final sub = repo.watchTracking(orderId: 'o1').listen(emissions.add);
      await pumpEventQueue();

      expect(emissions, hasLength(1));
      expect(emissions.single, isA<ErrorResponse>());
      expect((emissions.single as ErrorResponse).appError.message,
          'Tracking unavailable');

      // The same message must not spam the listener while the failure lasts.
      fcm.signal();
      await pumpEventQueue();
      expect(remote.callCount, 2);
      expect(emissions, hasLength(1));
      await sub.cancel();
    });

    test('recovers with a fresh snapshot after a failure', () async {
      remote.respond = (index) => index == 0
          ? ApiResponse(
              status: false, code: 500, message: 'Down', data: null)
          : _ok('ARRIVED');
      final emissions = <BaseResponse<TrackingEntity>>[];
      final sub = repo.watchTracking(orderId: 'o1').listen(emissions.add);
      await pumpEventQueue();

      fcm.signal();
      await pumpEventQueue();

      expect(emissions.first, isA<ErrorResponse>());
      expect((emissions.last as SuccessResponse).data.status,
          OrderStatus.arrived);
      await sub.cancel();
    });

    test('goes silent once the listener cancels', () async {
      final sub = repo.watchTracking(orderId: 'o1').listen((_) {});
      await pumpEventQueue();
      await sub.cancel();

      final before = remote.callCount;
      fcm.signal();
      await pumpEventQueue();

      expect(remote.callCount, before);
    });
  });

  group('fetchRoute', () {
    test('maps [lng, lat] pairs into geo points', () async {
      osrm.response = OsrmRouteModel(
        code: ApiRequestParams.osrmOkCode,
        routes: [
          OsrmRoute(
            geometry: OsrmGeometry(
              type: 'LineString',
              coordinates: [
                [31.23, 30.05],
                [31.24, 30.06],
              ],
            ),
          ),
        ],
      );

      final result = await repo.fetchRoute(
        from: const GeoPoint(30.05, 31.23),
        to: const GeoPoint(30.06, 31.24),
      );

      expect(
        (result as SuccessResponse).data,
        const [GeoPoint(30.05, 31.23), GeoPoint(30.06, 31.24)],
      );
    });

    test('fails when OSRM answers with a non-Ok code', () async {
      osrm.response = const OsrmRouteModel(code: 'NoMatch');

      final result = await repo.fetchRoute(
        from: const GeoPoint(30.05, 31.23),
        to: const GeoPoint(30.06, 31.24),
      );

      expect(result, isA<ErrorResponse>());
      expect((result as ErrorResponse).appError.message,
          'Route is unavailable.');
    });

    test('fails when OSRM returns an empty geometry', () async {
      osrm.response = OsrmRouteModel(
        code: ApiRequestParams.osrmOkCode,
        routes: [
          OsrmRoute(
            geometry: OsrmGeometry(type: 'LineString', coordinates: const []),
          ),
        ],
      );

      final result = await repo.fetchRoute(
        from: const GeoPoint(30.05, 31.23),
        to: const GeoPoint(30.06, 31.24),
      );

      expect(result, isA<ErrorResponse>());
    });
  });
}

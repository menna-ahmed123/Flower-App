import 'dart:async';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/api_request_params.dart';
import 'package:flower_app/features/order/data/data_sources/order_remote_data_source.dart';
import 'package:flower_app/features/order/data/data_sources/order_osrm_remote_data_source.dart';
import 'package:flower_app/features/order/data/data_sources/order_tracking_fcm_data_source.dart';
import 'package:flower_app/features/order/domain/entities/delivery_confirmation_entity.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/entities/order_entity.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/api_response.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/safe_call.dart';
import '../../domain/repos/order_repo.dart';
import '../mapper/delivery_confirmation_mapper.dart';
import '../mapper/order_model_mapper.dart';
import '../mapper/order_tracking_mapper.dart';
import '../mapper/osrm_route_mapper.dart';
@Injectable(as: OrderRepo)
class OrderRepoImpl implements OrderRepo {
  final OrderRemoteDataSource orderRemoteDataSource;
  final OrderTrackingFcmDataSource orderTrackingFcmDataSource;
  final OrderOsrmRemoteDataSource orderOsrmRemoteDataSource;
  final SafeCall safeCall;
  OrderRepoImpl(
    this.orderRemoteDataSource,
    this.safeCall,
    this.orderTrackingFcmDataSource,
    this.orderOsrmRemoteDataSource,
  );

  static const Duration _pollInterval = Duration(seconds: 20);
  static const String _routeUnavailableMessage = 'Route is unavailable.';

  @override
  Future<BaseResponse<List<OrderEntity>>> getAllOrders({
    int? page,
    int? pageSize,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await orderRemoteDataSource.getAllOrders(
        page: page,
        pageSize: pageSize,
      );
      return response.dataOrThrow().map((e) => e.toDomain()).toList();
    });
  }

  @override
  Future<BaseResponse<TrackingEntity>> orderTracking({required String orderId}) {
    return safeCall.safeApiCall(() async {
      final response = await orderRemoteDataSource.orderTracking(orderId: orderId);
      return response.dataOrThrow().toDomain();
    });
  }

  @override
  Future<BaseResponse<DeliveryConfirmationEntity>> confirmDelivery({
    required String orderId,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await orderRemoteDataSource.confirmDelivery(
        orderId: orderId,
      );
      return response.dataOrThrow().toDomain();
    });
  }

  @override
  Future<BaseResponse<List<GeoPoint>>> fetchRoute({
    required GeoPoint from,
    required GeoPoint to,
  }) {
    return safeCall.safeApiCall(() async {
      final model = await orderOsrmRemoteDataSource.fetchRoute(
        from: from,
        to: to,
      );
      final route = model.toDomain();
      if (model.code != ApiRequestParams.osrmOkCode || route.isEmpty) {
        throw ApiException(message: _routeUnavailableMessage);
      }
      return route;
    });
  }

  @override
  Stream<TrackingEntity> watchTracking({required String orderId}) {
    late final StreamController<TrackingEntity> controller;
    StreamSubscription<void>? changeSignalSubscription;
    Timer? pollTimer;
    TrackingEntity? lastEmitted;
    bool pollInFlight = false;

    void publish(TrackingEntity entity) {
      if (entity == lastEmitted) return;
      lastEmitted = entity;
      controller.add(entity);
      if (entity.isFinished) {
        pollTimer?.cancel();
        pollTimer = null;
      }
    }

    Future<void> poll() async {
      if (pollInFlight) return;
      pollInFlight = true;
      try {
        final result = await orderTracking(orderId: orderId);
        if (controller.isClosed) return;
        if (result case SuccessResponse(:final data)) {
          publish(data);
        } else if (result case ErrorResponse(:final appError)) {
          controller.addError(appError);
        }
      } finally {
        pollInFlight = false;
      }
    }

    controller = StreamController<TrackingEntity>.broadcast(
      onListen: () {
        changeSignalSubscription = orderTrackingFcmDataSource
            .watchChangeSignals(orderId: orderId)
            .listen((_) => unawaited(poll()));
        unawaited(poll());
        pollTimer = Timer.periodic(_pollInterval, (_) => unawaited(poll()));
      },
      onCancel: () {
        changeSignalSubscription?.cancel();
        changeSignalSubscription = null;
        pollTimer?.cancel();
        pollTimer = null;
      },
    );

    return controller.stream;
  }
}

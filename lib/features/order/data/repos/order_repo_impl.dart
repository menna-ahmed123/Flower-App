import 'dart:async';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/api_request_params.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
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
  Future<BaseResponse<TrackingEntity>> orderTracking({
    required String orderId,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await orderRemoteDataSource.orderTracking(
        orderId: orderId,
      );
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
        throw ApiException(message: AppString.routeUnavailable);
      }
      return route;
    });
  }

  @override
  Stream<BaseResponse<TrackingEntity>> watchTracking({
    required String orderId,
  }) {
    late final StreamController<BaseResponse<TrackingEntity>> controller;
    StreamSubscription<void>? changeSignalSubscription;
    Timer? pollTimer;
    TrackingEntity? lastEntity;
    String? lastErrorMessage;
    bool pollInFlight = false;
    bool pollQueued = false;

    void publish(TrackingEntity entity) {
      if (entity == lastEntity) return;
      lastEntity = entity;
      lastErrorMessage = null;
      controller.add(SuccessResponse(entity));
      if (entity.isFinished) {
        pollTimer?.cancel();
        pollTimer = null;
      }
    }

    // Failures travel as data events, so no raw exception ever reaches the
    // cubit; the identical message is reported once until the next change.
    void publishFailure(AppError error) {
      if (error.message == lastErrorMessage) return;
      lastErrorMessage = error.message;
      controller.add(ErrorResponse(appError: error));
    }

    Future<void> poll() async {
      if (pollInFlight) {
        // A signal during a request must not be lost: remember it and run
        // exactly one more fetch once the in-flight request settles.
        pollQueued = true;
        return;
      }
      pollInFlight = true;
      try {
        do {
          pollQueued = false;
          final result = await orderTracking(orderId: orderId);
          if (controller.isClosed) return;
          switch (result) {
            case SuccessResponse(:final data):
              publish(data);
            case ErrorResponse(:final appError):
              publishFailure(appError);
          }
        } while (pollQueued);
      } finally {
        pollInFlight = false;
      }
    }

    controller = StreamController<BaseResponse<TrackingEntity>>.broadcast(
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
        unawaited(controller.close());
      },
    );

    return controller.stream;
  }
}

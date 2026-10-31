import 'dart:async';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/domain/repos/order_repo.dart';
import 'package:flower_app/features/order/domain/use_cases/watch_order_tracking_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/tracking_fixtures.dart';
import 'watch_order_tracking_use_case_test.mocks.dart';

@GenerateMocks([OrderRepo])
void main() {
  provideDummy<Stream<BaseResponse<TrackingEntity>>>(
    const Stream<BaseResponse<TrackingEntity>>.empty(),
  );

  late MockOrderRepo orderRepo;
  late WatchOrderTrackingUseCase useCase;

  setUp(() {
    orderRepo = MockOrderRepo();
    useCase = WatchOrderTrackingUseCase(orderRepo);
  });

  group('call', () {
    test('passes the order id to the repository', () {
      when(orderRepo.watchTracking(orderId: anyNamed('orderId')))
          .thenAnswer(
              (_) => const Stream<BaseResponse<TrackingEntity>>.empty());

      useCase.call(orderId: 'o1');

      verify(orderRepo.watchTracking(orderId: 'o1')).called(1);
    });

    test('hands over every response the repository emits', () async {
      final source = StreamController<BaseResponse<TrackingEntity>>();
      when(orderRepo.watchTracking(orderId: 'o1'))
          .thenAnswer((_) => source.stream);

      final emissions = <OrderStatus>[];
      final sub = useCase.call(orderId: 'o1').listen((response) {
        if (response case SuccessResponse(:final data)) {
          emissions.add(data.status);
        }
      });
      source.add(SuccessResponse(
        trackingFixture(status: OrderStatus.outForDelivery),
      ));
      source.add(SuccessResponse(
        trackingFixture(status: OrderStatus.awaitingDeliveryConfirmation),
      ));
      await pumpEventQueue();

      expect(emissions, [
        OrderStatus.outForDelivery,
        OrderStatus.awaitingDeliveryConfirmation,
      ]);
      await sub.cancel();
      await source.close();
    });
  });
}

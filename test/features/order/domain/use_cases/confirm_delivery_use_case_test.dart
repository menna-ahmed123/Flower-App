import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/order/domain/entities/delivery_confirmation_entity.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/repos/order_repo.dart';
import 'package:flower_app/features/order/domain/use_cases/confirm_delivery_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'confirm_delivery_use_case_test.mocks.dart';

@GenerateMocks([OrderRepo])
void main() {
  provideDummy<BaseResponse<DeliveryConfirmationEntity>>(
    const SuccessResponse<DeliveryConfirmationEntity>(
      DeliveryConfirmationEntity(orderId: 'o1', status: OrderStatus.delivered),
    ),
  );
  provideDummy<BaseResponse<DeliveryConfirmationEntity>>(
    ErrorResponse<DeliveryConfirmationEntity>(
      appError: BadResponseError('Nope'),
    ),
  );

  late MockOrderRepo orderRepo;
  late ConfirmDeliveryUseCase useCase;

  setUp(() {
    orderRepo = MockOrderRepo();
    useCase = ConfirmDeliveryUseCase(orderRepo);
  });

  group('call', () {
    test('passes the order id to the repository', () async {
      when(orderRepo.confirmDelivery(orderId: anyNamed('orderId')))
          .thenAnswer((_) async => const SuccessResponse(
                DeliveryConfirmationEntity(
                    orderId: 'other', status: OrderStatus.delivered),
              ));

      await useCase.call(orderId: 'o1');

      verify(orderRepo.confirmDelivery(orderId: 'o1')).called(1);
    });

    test('returns the repository answer unchanged', () async {
      final confirmation = const DeliveryConfirmationEntity(
        orderId: 'o1',
        status: OrderStatus.delivered,
        confirmedAt: null,
      );
      when(orderRepo.confirmDelivery(orderId: 'o1'))
          .thenAnswer((_) async => SuccessResponse(confirmation));

      final result = await useCase.call(orderId: 'o1');

      expect(result, isA<SuccessResponse>());
      expect((result as SuccessResponse).data, confirmation);
    });

    test('relays a failure untouched', () async {
      when(orderRepo.confirmDelivery(orderId: 'o1')).thenAnswer(
        (_) async =>
            ErrorResponse(appError: BadResponseError('Order already closed')),
      );

      final result = await useCase.call(orderId: 'o1');

      expect(result, isA<ErrorResponse>());
      expect((result as ErrorResponse).appError.message,
          'Order already closed');
    });
  });
}

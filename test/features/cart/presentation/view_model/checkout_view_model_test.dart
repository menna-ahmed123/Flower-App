import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/use_cases/cart_use_case.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../cart_test_support.dart';

void main() {
  const address = AddressEntity(id: 'address-1', city: 'Cairo');
  const preview = CartEntity(
    id: 'cart-1',
    items: [],
    subtotal: 100,
    deliveryFee: 0,
    total: 100,
    itemCount: 1,
  );

  late FakeCartRepo cartRepo;
  late CheckoutViewModel viewModel;

  setUp(() {
    cartRepo = FakeCartRepo(getCartResponse: const SuccessResponse(preview));
    viewModel = CheckoutViewModel(CartUseCase(cartRepo));
  });

  tearDown(() async {
    await viewModel.close();
  });

  Future<void> readyToSubmit() async {
    await viewModel.doEvent(SelectCheckoutAddress(address));
    await viewModel.doEvent(
      SelectCheckoutPayment(CheckoutPaymentMethods.cashOnDelivery),
    );
  }

  test('loads checkout preview from cart', () async {
    await viewModel.doEvent(LoadCheckoutPreview());

    expect(cartRepo.getCartCalls, 1);
    expect(viewModel.state.previewState.data?.total, 100);
  });

  test('selecting an address refreshes the preview once', () async {
    await viewModel.doEvent(SelectCheckoutAddress(address));
    await viewModel.doEvent(SelectCheckoutAddress(address));

    expect(viewModel.state.selectedAddress, address);
    expect(cartRepo.getCartCalls, 1);
  });

  test('toggling gift keeps recipient values', () async {
    await viewModel.doEvent(
      UpdateGiftRecipient(name: 'Mona', phone: '01001112222'),
    );
    await viewModel.doEvent(ToggleCheckoutGift(true));
    await viewModel.doEvent(ToggleCheckoutGift(false));

    expect(viewModel.state.recipientName, 'Mona');
    expect(viewModel.state.recipientPhone, '01001112222');
    expect(viewModel.state.isGift, isFalse);
  });

  test('blocks place order without address or payment', () async {
    await viewModel.doEvent(SubmitPlaceOrder());

    expect(cartRepo.placeOrderCalls, 0);
    expect(viewModel.state.showValidation, isTrue);
  });

  test('blocks place order when gift recipient is invalid', () async {
    await readyToSubmit();
    await viewModel.doEvent(ToggleCheckoutGift(true));
    await viewModel.doEvent(SubmitPlaceOrder());

    expect(cartRepo.placeOrderCalls, 0);
    expect(viewModel.state.showValidation, isTrue);
  });

  test('places order without a request body and goes to confirmation', () async {
    await readyToSubmit();
    await viewModel.doEvent(SubmitPlaceOrder());

    expect(cartRepo.placeOrderCalls, 1);
    expect(viewModel.state.destination, CheckoutDestination.confirmation);
  });

  test('credit card place order goes to payment', () async {
    await viewModel.doEvent(SelectCheckoutAddress(address));
    await viewModel.doEvent(
      SelectCheckoutPayment(CheckoutPaymentMethods.creditCard),
    );
    await viewModel.doEvent(SubmitPlaceOrder());

    expect(viewModel.state.destination, CheckoutDestination.payment);
  });

  test('failed place order keeps form state', () async {
    cartRepo.placeOrderResponse = ErrorResponse(
      appError: BadResponseError(AppString.orderFailed),
    );
    await readyToSubmit();
    await viewModel.doEvent(SubmitPlaceOrder());

    expect(viewModel.state.selectedAddress, address);
    expect(
      viewModel.state.paymentMethod,
      CheckoutPaymentMethods.cashOnDelivery,
    );
    expect(viewModel.state.destination, isNull);
    expect(viewModel.state.submitState.errorMessage, AppString.orderFailed);
  });

  test('prevents duplicate place order while submitting', () async {
    cartRepo.placeOrderDelay = const Duration(milliseconds: 20);
    await readyToSubmit();
    final first = viewModel.doEvent(SubmitPlaceOrder());
    await Future<void>.delayed(Duration.zero);
    await viewModel.doEvent(SubmitPlaceOrder());
    await first;

    expect(cartRepo.placeOrderCalls, 1);
  });

  test('payment success navigates to confirmation', () async {
    await viewModel.doEvent(ProcessCheckoutPayment());

    expect(cartRepo.paymentCalls, 1);
    expect(viewModel.state.destination, CheckoutDestination.confirmation);
  });
}

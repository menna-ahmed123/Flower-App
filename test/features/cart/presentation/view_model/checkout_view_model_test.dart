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
  _previewTests();
  _giftTests();
  _submitGuardTests();
  _placeOrderTests();
  _paymentTests();
}

const _address = AddressEntity(id: 'address-1', city: 'Cairo');
const _preview = CartEntity(
  id: 'cart-1',
  items: [],
  subtotal: 100,
  deliveryFee: 0,
  total: 100,
  itemCount: 1,
);

class CheckoutCase {
  late FakeCartRepo cartRepo;
  late CheckoutViewModel viewModel;

  void setUp() {
    cartRepo = FakeCartRepo(getCartResponse: const SuccessResponse(_preview));
    viewModel = CheckoutViewModel(CartUseCase(cartRepo));
  }

  Future<void> tearDown() => viewModel.close();

  Future<void> readyToSubmit() async {
    await viewModel.doEvent(const SelectCheckoutAddress(_address));
    await viewModel.doEvent(
      const SelectCheckoutPayment(CheckoutPaymentMethods.cashOnDelivery),
    );
  }
}

void _previewTests() {
  group('preview', () {
    final c = CheckoutCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    test('loads checkout preview from cart', () => _loadsPreview(c));
    test('selecting an address refreshes the preview once', () {
      return _selectsAddressOnce(c);
    });
  });
}

Future<void> _loadsPreview(CheckoutCase c) async {
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  expect(c.cartRepo.getCartCalls, 1);
  expect(c.viewModel.state.previewState.data?.total, 100);
}

Future<void> _selectsAddressOnce(CheckoutCase c) async {
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  expect(c.viewModel.state.selectedAddress, _address);
  expect(c.cartRepo.getCartCalls, 1);
}

void _giftTests() {
  group('gift', () {
    final c = CheckoutCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    test('toggling gift keeps recipient values', () => _keepsRecipient(c));
  });
}

Future<void> _keepsRecipient(CheckoutCase c) async {
  await c.viewModel.doEvent(
    const UpdateGiftRecipient(name: 'Mona', phone: '01001112222'),
  );
  await c.viewModel.doEvent(const ToggleCheckoutGift(true));
  await c.viewModel.doEvent(const ToggleCheckoutGift(false));
  expect(c.viewModel.state.recipientName, 'Mona');
  expect(c.viewModel.state.recipientPhone, '01001112222');
  expect(c.viewModel.state.isGift, isFalse);
}

void _submitGuardTests() {
  group('submit guards', () {
    final c = CheckoutCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    test('blocks place order without address or payment', () => _blocksEmpty(c));
    test('blocks place order when gift recipient is invalid', () {
      return _blocksInvalidGift(c);
    });
  });
}

Future<void> _blocksEmpty(CheckoutCase c) async {
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.cartRepo.placeOrderCalls, 0);
  expect(c.viewModel.state.showValidation, isTrue);
}

Future<void> _blocksInvalidGift(CheckoutCase c) async {
  await c.readyToSubmit();
  await c.viewModel.doEvent(const ToggleCheckoutGift(true));
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.cartRepo.placeOrderCalls, 0);
  expect(c.viewModel.state.showValidation, isTrue);
}

void _placeOrderTests() {
  group('place order', () {
    final c = CheckoutCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    test('places order without a request body and goes to confirmation', () {
      return _placesCashOrder(c);
    });
    test('credit card place order goes to payment', () => _placesCardOrder(c));
    test('failed place order keeps form state', () => _keepsFormOnFailure(c));
    test('prevents duplicate place order while submitting', () {
      return _preventsDuplicateSubmit(c);
    });
  });
}

Future<void> _placesCashOrder(CheckoutCase c) async {
  await c.readyToSubmit();
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.cartRepo.placeOrderCalls, 1);
  expect(c.viewModel.state.destination, CheckoutDestination.confirmation);
}

Future<void> _placesCardOrder(CheckoutCase c) async {
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(
    const SelectCheckoutPayment(CheckoutPaymentMethods.creditCard),
  );
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.viewModel.state.destination, CheckoutDestination.payment);
}

Future<void> _keepsFormOnFailure(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = ErrorResponse(
    appError: BadResponseError(AppString.orderFailed),
  );
  await c.readyToSubmit();
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.viewModel.state.selectedAddress, _address);
  expect(c.viewModel.state.paymentMethod, CheckoutPaymentMethods.cashOnDelivery);
  expect(c.viewModel.state.destination, isNull);
  expect(c.viewModel.state.submitState.errorMessage, AppString.orderFailed);
}

Future<void> _preventsDuplicateSubmit(CheckoutCase c) async {
  c.cartRepo.placeOrderDelay = const Duration(milliseconds: 20);
  await c.readyToSubmit();
  final first = c.viewModel.doEvent(const SubmitPlaceOrder());
  await Future<void>.delayed(Duration.zero);
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  await first;
  expect(c.cartRepo.placeOrderCalls, 1);
}

void _paymentTests() {
  group('payment', () {
    final c = CheckoutCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    test('payment success navigates to confirmation', () => _paysSuccessfully(c));
  });
}

Future<void> _paysSuccessfully(CheckoutCase c) async {
  await c.viewModel.doEvent(const ProcessCheckoutPayment());
  expect(c.cartRepo.paymentCalls, 1);
  expect(c.viewModel.state.destination, CheckoutDestination.confirmation);
}

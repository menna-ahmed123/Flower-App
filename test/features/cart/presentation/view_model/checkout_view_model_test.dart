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
    cartRepo = FakeCartRepo(previewResponse: const SuccessResponse(_preview));
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
    test('address required preview opens add address', () {
      return _previewAddressRequired(c);
    });
    test('default address preview omits addressId', () {
      return _defaultAddressOmitsId(c);
    });
    test('selected non-default address sends addressId', () {
      return _selectedAddressSendsId(c);
    });
    test('gift preview omits addressId and sends gift', () {
      return _giftPreviewOmitsAddressId(c);
    });
    test('address not serviceable stays on checkout', () {
      return _previewAddressNotServiceable(c);
    });
    test('empty cart preview opens the empty cart state', () {
      return _previewCartEmpty(c);
    });
  });
}

Future<void> _loadsPreview(CheckoutCase c) async {
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  expect(c.cartRepo.previewCalls, 1);
  expect(c.viewModel.state.previewState.data?.total, 100);
}

Future<void> _selectsAddressOnce(CheckoutCase c) async {
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  expect(c.viewModel.state.selectedAddress, _address);
  expect(c.cartRepo.previewCalls, 1);
}

Future<void> _previewAddressRequired(CheckoutCase c) async {
  c.cartRepo.previewResponse = ErrorResponse(
    appError: BadResponseError('required', code: 'AddressRequired'),
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  expect(c.viewModel.state.destination, CheckoutDestination.addAddress);
}

Future<void> _defaultAddressOmitsId(CheckoutCase c) async {
  const address = AddressEntity(
    id: 'address-default',
    city: 'Cairo',
    isDefault: true,
  );
  await c.viewModel.doEvent(const SelectCheckoutAddress(address));
  expect(c.cartRepo.lastPreviewAddressId, isNull);
  expect(c.cartRepo.lastPreviewGift, isNull);
}

Future<void> _selectedAddressSendsId(CheckoutCase c) async {
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  expect(c.cartRepo.lastPreviewAddressId, 'address-1');
  expect(c.cartRepo.lastPreviewGift, isNull);
}

Future<void> _giftPreviewOmitsAddressId(CheckoutCase c) async {
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(
    const UpdateGiftRecipient(name: 'Mona', phone: '01001112222'),
  );
  await c.viewModel.doEvent(const ToggleCheckoutGift(true));
  expect(c.cartRepo.lastPreviewAddressId, isNull);
  expect(c.cartRepo.lastPreviewGift?.recipientName, 'Mona');
  expect(c.cartRepo.lastPreviewGift?.phone, '01001112222');
}

Future<void> _previewAddressNotServiceable(CheckoutCase c) async {
  c.cartRepo.previewResponse = ErrorResponse(
    appError: BadResponseError('unserviceable', code: 'AddressNotServiceable'),
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  expect(c.viewModel.state.destination, isNull);
  expect(
    c.viewModel.state.previewState.errorMessage,
    AppString.deliveryUnavailable,
  );
}

Future<void> _previewCartEmpty(CheckoutCase c) async {
  c.cartRepo.previewResponse = ErrorResponse(
    appError: BadResponseError('empty', code: 'CartEmpty'),
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  expect(c.viewModel.state.destination, CheckoutDestination.emptyCart);
  expect(c.viewModel.state.previewState.errorMessage, AppString.cartIsEmpty);
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
    test(
      'blocks place order without address or payment',
      () => _blocksEmpty(c),
    );
    test('blocks place order when gift recipient is invalid', () {
      return _blocksInvalidGift(c);
    });
    test('blocks place order without a successful preview', () {
      return _blocksFailedPreview(c);
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

Future<void> _blocksFailedPreview(CheckoutCase c) async {
  c.cartRepo.previewResponse = ErrorResponse(
    appError: BadResponseError('failed'),
  );
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(
    const SelectCheckoutPayment(CheckoutPaymentMethods.cashOnDelivery),
  );
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.cartRepo.placeOrderCalls, 0);
  expect(c.viewModel.state.showValidation, isTrue);
}

void _placeOrderTests() {
  group('place order', () {
    final c = CheckoutCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    test('places cash order and goes to confirmation', () {
      return _placesCashOrder(c);
    });
    test('credit card place order goes to payment', () => _placesCardOrder(c));
    test('place order uses payment method value from preview', () {
      return _usesPreviewPaymentMethod(c);
    });
    test('missing paymentRequired does not confirm cash order', () {
      return _rejectsMissingPaymentRequired(c);
    });
    test('failed place order keeps form state', () => _keepsFormOnFailure(c));
    test('prevents duplicate place order while submitting', () {
      return _preventsDuplicateSubmit(c);
    });
    test('retries dependency errors with the same idempotency key', () {
      return _retriesDependencyUnavailable(c);
    });
    test('items unavailable shows backend item details', () {
      return _showsItemsUnavailable(c);
    });
    test('price changed updates preview totals', () {
      return _appliesPriceChanged(c);
    });
  });
}

Future<void> _placesCashOrder(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = const SuccessResponse(
    OrderEntity(orderId: 'order-cash', status: 0, paymentRequired: false),
  );
  await c.readyToSubmit();
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.cartRepo.placeOrderCalls, 1);
  expect(c.cartRepo.lastExpectedTotal, 100);
  expect(c.viewModel.state.destination, CheckoutDestination.confirmation);
  expect(c.viewModel.state.orderId, 'order-cash');
}

Future<void> _rejectsMissingPaymentRequired(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = const SuccessResponse(OrderEntity(status: 0));
  await c.readyToSubmit();
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.viewModel.state.destination, isNull);
  expect(c.viewModel.state.submitState.errorMessage, AppString.orderFailed);
}

Future<void> _placesCardOrder(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = const SuccessResponse(
    OrderEntity(
      orderId: 'order-card',
      paymentRequired: true,
      status: 6,
      sessionUrl: 'https://pay.example/session',
      successUrl: 'https://app.example/success',
      cancelUrl: 'https://app.example/cancel',
    ),
  );
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(
    const SelectCheckoutPayment(CheckoutPaymentMethods.creditCard),
  );
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.viewModel.state.destination, CheckoutDestination.payment);
  expect(c.viewModel.state.orderId, 'order-card');
  expect(c.viewModel.state.sessionUrl, 'https://pay.example/session');
  expect(c.viewModel.state.successUrl, 'https://app.example/success');
  expect(c.viewModel.state.cancelUrl, 'https://app.example/cancel');
}

Future<void> _usesPreviewPaymentMethod(CheckoutCase c) async {
  c.cartRepo.previewResponse = const SuccessResponse(
    CartEntity(
      id: 'cart-1',
      items: [],
      subtotal: 100,
      deliveryFee: 0,
      total: 100,
      itemCount: 1,
      paymentMethods: [
        PaymentMethodEntity(name: 'Visa', value: 2),
        PaymentMethodEntity(name: 'Wallet', value: 3),
      ],
    ),
  );
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(const SelectCheckoutPayment('Visa'));
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.cartRepo.lastPaymentMethod, 2);
}

Future<void> _keepsFormOnFailure(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = ErrorResponse(
    appError: BadResponseError(AppString.orderFailed),
  );
  await c.readyToSubmit();
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.viewModel.state.selectedAddress, _address);
  expect(
    c.viewModel.state.paymentMethod,
    CheckoutPaymentMethods.cashOnDelivery,
  );
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

Future<void> _retriesDependencyUnavailable(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = ErrorResponse(
    appError: BadResponseError('unavailable', code: 'DependencyUnavailable'),
  );
  await c.readyToSubmit();
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.cartRepo.placeOrderCalls, 2);
  expect(c.cartRepo.idempotencyKeys, hasLength(2));
  expect(c.cartRepo.idempotencyKeys[0], c.cartRepo.idempotencyKeys[1]);
}

Future<void> _showsItemsUnavailable(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = ErrorResponse(
    appError: BadResponseError(
      'unavailable',
      code: 'ItemsUnavailable',
      data: {
        'items': [
          {
            'name': 'Carnations',
            'requestedQuantity': 3,
            'availableQuantity': 0,
          },
        ],
      },
    ),
  );
  await c.readyToSubmit();
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.viewModel.state.destination, isNull);
  expect(
    c.viewModel.state.submitState.errorMessage,
    'Carnations: 3 requested, 0 available',
  );
}

Future<void> _appliesPriceChanged(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = ErrorResponse(
    appError: BadResponseError(
      'changed',
      code: 'PriceChanged',
      data: {
        'summary': {
          'subtotal': 200,
          'deliveryFee': 50,
          'discount': 0,
          'total': 250,
        },
      },
    ),
  );
  await c.readyToSubmit();
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.viewModel.state.destination, isNull);
  expect(c.viewModel.state.previewState.data?.total, 250);
  expect(c.viewModel.state.previewState.data?.deliveryFee, 50);
  expect(c.viewModel.state.submitState.errorMessage, AppString.priceChanged);
}

void _paymentTests() {
  group('payment', () {
    final c = CheckoutCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    test(
      'payment success navigates to confirmation',
      () => _paysSuccessfully(c),
    );
  });
}

Future<void> _paysSuccessfully(CheckoutCase c) async {
  await c.viewModel.doEvent(const ProcessCheckoutPayment());
  expect(c.cartRepo.paymentCalls, 1);
  expect(c.viewModel.state.destination, CheckoutDestination.confirmation);
}

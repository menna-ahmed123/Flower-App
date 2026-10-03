import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../cart_test_support.dart';

void main() {
  _detailsTests();
  _estimateTests();
  _giftTests();
  _submitGuardTests();
  _placeOrderTests();
  _paymentTests();
}

const _address = AddressEntity(id: 'address-1', city: 'Cairo');
const _line = CartItemEntity(
  id: 'item-1',
  productId: 'product-1',
  name: 'Red Rose',
  imageUrl: '',
  price: 100,
  quantity: 1,
);
const _stockedCart = CartEntity(
  id: 'cart-1',
  items: [_line],
  subtotal: 100,
  deliveryFee: 0,
  total: 100,
  itemCount: 1,
);
const _details = CartEntity(
  id: 'cart-1',
  items: [],
  subtotal: 100,
  deliveryFee: 0,
  total: 100,
  itemCount: 0,
  paymentMethods: checkoutPaymentMethods,
);

class CheckoutCase {
  late FakeCartRepo cartRepo;
  late CheckoutViewModel viewModel;

  void setUp() {
    cartRepo = FakeCartRepo(
      getCartResponse: const SuccessResponse(_stockedCart),
      detailsResponse: const SuccessResponse(_details),
    );
    viewModel = testCheckoutViewModel(cartRepo);
  }

  Future<void> tearDown() => viewModel.close();

  Future<void> readyToSubmit() async {
    await viewModel.doEvent(const LoadCheckoutPreview());
    await viewModel.doEvent(const SelectCheckoutAddress(_address));
    await viewModel.doEvent(
      const SelectCheckoutPayment(CheckoutPaymentMethods.cashOnDelivery),
    );
  }
}

void _detailsTests() {
  group('checkout details', () {
    final c = CheckoutCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    test('loads checkout details for the cart id', () => _loadsDetails(c));
    test('address required opens add address', () => _addressRequired(c));
    test('non-serviceable address stays on checkout', () {
      return _notServiceable(c);
    });
    test('empty cart opens the empty cart state', () => _emptyCart(c));
  });
}

Future<void> _loadsDetails(CheckoutCase c) async {
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  expect(c.cartRepo.getCartCalls, 1);
  expect(c.cartRepo.detailsCalls, 1);
  expect(c.cartRepo.lastDetailsCartId, 'cart-1');
  expect(c.cartRepo.estimateCalls, 0);
  expect(c.viewModel.state.previewState.data?.total, 100);
  expect(c.viewModel.state.paymentMethods, checkoutPaymentMethods);
}

Future<void> _addressRequired(CheckoutCase c) async {
  c.cartRepo.detailsResponse = ErrorResponse(
    appError: BadResponseError('required', code: 'AddressRequired'),
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  expect(c.viewModel.state.destination, CheckoutDestination.addAddress);
}

Future<void> _notServiceable(CheckoutCase c) async {
  c.cartRepo.detailsResponse = const SuccessResponse(
    CartEntity(
      id: 'cart-1',
      items: [],
      subtotal: 517.90,
      deliveryFee: 0,
      total: 517.90,
      itemCount: 0,
      isServiceable: false,
      paymentMethods: checkoutPaymentMethods,
    ),
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  expect(c.viewModel.state.destination, isNull);
  expect(c.viewModel.state.previewState.data?.total, 517.90);
  expect(c.viewModel.state.previewState.data?.isServiceable, isFalse);
  expect(
    c.viewModel.state.previewState.errorMessage,
    AppString.deliveryUnavailable,
  );
  expect(c.viewModel.state.canSubmit, isFalse);
}

Future<void> _emptyCart(CheckoutCase c) async {
  c.cartRepo.getCartResponse = const SuccessResponse(CartEntity.empty());
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  expect(c.cartRepo.detailsCalls, 0);
  expect(c.viewModel.state.destination, CheckoutDestination.emptyCart);
  expect(c.viewModel.state.previewState.errorMessage, AppString.cartIsEmpty);
}

void _estimateTests() {
  group('delivery estimate', () {
    final c = CheckoutCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    test('selecting an address requests one estimate', () {
      return _selectsAddressOnce(c);
    });
    test('an address chosen while details load estimates once', () {
      return _estimatesOnceDuringLoad(c);
    });
    test('default address still sends AddressId and CartId', () {
      return _defaultAddressSendsIds(c);
    });
    test('estimate updates totals and does not invent a missing fee', () {
      return _appliesEstimate(c);
    });
    test('non-serviceable estimate blocks submit', () {
      return _estimateNotServiceable(c);
    });
  });
}

Future<void> _estimatesOnceDuringLoad(CheckoutCase c) async {
  c.cartRepo.detailsDelay = const Duration(milliseconds: 30);
  final load = c.viewModel.doEvent(const LoadCheckoutPreview());
  await Future<void>.delayed(Duration.zero);
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await load;
  expect(c.cartRepo.detailsCalls, 1);
  expect(c.cartRepo.estimateCalls, 1);
  expect(c.cartRepo.lastEstimateAddressId, 'address-1');
  expect(c.cartRepo.lastEstimateCartId, 'cart-1');
  expect(c.viewModel.state.previewState.data?.total, 100);
}

Future<void> _selectsAddressOnce(CheckoutCase c) async {
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  expect(c.viewModel.state.selectedAddress, _address);
  expect(c.cartRepo.estimateCalls, 1);
  expect(c.cartRepo.lastEstimateAddressId, 'address-1');
  expect(c.cartRepo.lastEstimateCartId, 'cart-1');
}

Future<void> _defaultAddressSendsIds(CheckoutCase c) async {
  const address = AddressEntity(
    id: 'address-default',
    city: 'Cairo',
    isDefault: true,
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  await c.viewModel.doEvent(const SelectCheckoutAddress(address));
  expect(c.cartRepo.lastEstimateAddressId, 'address-default');
  expect(c.cartRepo.lastEstimateCartId, 'cart-1');
}

Future<void> _appliesEstimate(CheckoutCase c) async {
  c.cartRepo.estimateResponse = const SuccessResponse(
    DeliveryEstimateEntity(deliveryFee: 25, total: 125, hasData: true),
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  expect(c.viewModel.state.previewState.data?.subtotal, 100);
  expect(c.viewModel.state.previewState.data?.deliveryFee, 25);
  expect(c.viewModel.state.previewState.data?.total, 125);
  c.cartRepo.estimateResponse = const SuccessResponse(DeliveryEstimateEntity());
  await c.viewModel.doEvent(
    const SelectCheckoutAddress(AddressEntity(id: 'address-2')),
  );
  expect(c.viewModel.state.previewState.data?.deliveryFee, 25);
  expect(c.viewModel.state.previewState.data?.total, 125);
}

Future<void> _estimateNotServiceable(CheckoutCase c) async {
  c.cartRepo.estimateResponse = const SuccessResponse(
    DeliveryEstimateEntity(isServiceable: false, hasData: true),
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(
    const SelectCheckoutPayment(CheckoutPaymentMethods.cashOnDelivery),
  );
  expect(c.viewModel.state.previewState.data?.isServiceable, isFalse);
  expect(c.viewModel.state.canSubmit, isFalse);
  expect(
    c.viewModel.state.previewState.errorMessage,
    AppString.deliveryUnavailable,
  );
}

void _giftTests() {
  group('gift', () {
    final c = CheckoutCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    test('toggling gift does not request another estimate', () {
      return _giftStaysLocal(c);
    });
    test('toggling gift keeps recipient values', () => _keepsRecipient(c));
  });
}

Future<void> _giftStaysLocal(CheckoutCase c) async {
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(
    const UpdateGiftRecipient(name: 'Mona', phone: '01001112222'),
  );
  await c.viewModel.doEvent(const ToggleCheckoutGift(true));
  expect(c.cartRepo.estimateCalls, 1);
  expect(c.cartRepo.detailsCalls, 1);
  expect(c.viewModel.state.isGift, isTrue);
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
    test('blocks place order without address or payment', () {
      return _blocksEmpty(c);
    });
    test('blocks place order when gift recipient is invalid', () {
      return _blocksInvalidGift(c);
    });
    test('blocks place order without checkout details', () {
      return _blocksFailedDetails(c);
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

Future<void> _blocksFailedDetails(CheckoutCase c) async {
  c.cartRepo.detailsResponse = ErrorResponse(
    appError: BadResponseError('failed'),
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
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
    test('places a COD order and opens confirmation', () => _placesCod(c));
    test('places a card order and opens payment', () => _placesCard(c));
    test('places a gift order with the recipient', () => _placesGift(c));
    test('a placed order without PLACED status does not confirm', () {
      return _rejectsUnplaced(c);
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
    test(
      'price changed updates checkout totals',
      () => _appliesPriceChanged(c),
    );
  });
}

Future<void> _placesCod(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = const SuccessResponse(
    OrderEntity(
      orderId: 'order-cash',
      orderNumber: 'ORD-1',
      status: 'PLACED',
      paymentMethod: 'COD',
      paymentStatus: 'PENDING',
      total: 100,
    ),
  );
  await c.readyToSubmit();
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.cartRepo.placeOrderCalls, 1);
  expect(c.cartRepo.lastCartId, 'cart-1');
  expect(c.cartRepo.lastAddressId, 'address-1');
  expect(c.cartRepo.lastIsGift, isFalse);
  expect(c.cartRepo.lastRecipientName, isNull);
  expect(c.cartRepo.lastPaymentMethod, 'cod');
  expect(c.cartRepo.lastPaymentGateway, isNull);
  expect(c.cartRepo.idempotencyKeys.single, isNotEmpty);
  expect(c.viewModel.state.destination, CheckoutDestination.confirmation);
  expect(c.viewModel.state.orderId, 'order-cash');
  expect(c.viewModel.state.sessionUrl, isNull);
}

Future<void> _placesCard(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = const SuccessResponse(
    OrderEntity(
      orderId: 'order-card',
      status: 'PLACED',
      paymentMethod: 'Card',
      paymentStatus: 'PENDING',
      total: 100,
    ),
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(
    const SelectCheckoutPayment(CheckoutPaymentMethods.creditCard),
  );
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.cartRepo.lastPaymentMethod, 'Card');
  expect(c.cartRepo.lastPaymentGateway, 'Stripe');
  expect(c.viewModel.state.destination, CheckoutDestination.payment);
  expect(c.viewModel.state.orderId, 'order-card');
  expect(c.viewModel.state.sessionUrl, isNull);
}

Future<void> _placesGift(CheckoutCase c) async {
  await c.readyToSubmit();
  await c.viewModel.doEvent(
    const UpdateGiftRecipient(name: 'Nada Ahmed', phone: '01098887966'),
  );
  await c.viewModel.doEvent(const ToggleCheckoutGift(true));
  c.cartRepo.placeOrderResponse = const SuccessResponse(
    OrderEntity(orderId: 'order-gift', status: 'PLACED', paymentMethod: 'COD'),
  );
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.cartRepo.lastIsGift, isTrue);
  expect(c.cartRepo.lastRecipientName, 'Nada Ahmed');
  expect(c.cartRepo.lastRecipientPhone, '01098887966');
  expect(c.cartRepo.lastAddressId, 'address-1');
  expect(c.cartRepo.lastPaymentMethod, 'cod');
  expect(c.viewModel.state.destination, CheckoutDestination.confirmation);
}

Future<void> _rejectsUnplaced(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = const SuccessResponse(
    OrderEntity(orderId: 'order-cash', paymentMethod: 'COD'),
  );
  await c.readyToSubmit();
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  expect(c.viewModel.state.destination, isNull);
  expect(c.viewModel.state.submitState.errorMessage, AppString.orderFailed);
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
    test('card checkout stores the Stripe session and does not confirm', () {
      return _createsCheckoutSession(c);
    });
    test('payment failure does not confirm the order', () {
      return _paymentFails(c);
    });
  });
}

Future<void> _createsCheckoutSession(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = const SuccessResponse(
    OrderEntity(orderId: 'order-card', status: 'PLACED', total: 58.98),
  );
  c.cartRepo.paymentResponse = const SuccessResponse(
    PaymentCheckoutEntity(
      checkoutUrl: 'https://checkout.stripe.com/c/pay/cs_test',
      stripeSessionId: 'cs_test',
      paymentAttemptId: 'attempt-1',
    ),
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(
    const SelectCheckoutPayment(CheckoutPaymentMethods.creditCard),
  );
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  await c.viewModel.doEvent(const ProcessCheckoutPayment());
  expect(c.cartRepo.paymentCalls, 1);
  expect(c.cartRepo.lastPaymentOrderId, 'order-card');
  expect(c.cartRepo.lastAmountTotal, 58.98);
  expect(c.cartRepo.lastCurrency, 'USD');
  expect(
    c.viewModel.state.sessionUrl,
    'https://checkout.stripe.com/c/pay/cs_test',
  );
  expect(c.viewModel.state.stripeSessionId, 'cs_test');
  expect(c.viewModel.state.paymentAttemptId, 'attempt-1');
  expect(c.viewModel.state.destination, CheckoutDestination.payment);
}

Future<void> _paymentFails(CheckoutCase c) async {
  c.cartRepo.placeOrderResponse = const SuccessResponse(
    OrderEntity(orderId: 'order-card', status: 'PLACED', total: 100),
  );
  c.cartRepo.paymentResponse = ErrorResponse(
    appError: BadResponseError('Payment checkout failed'),
  );
  await c.viewModel.doEvent(const LoadCheckoutPreview());
  await c.viewModel.doEvent(const SelectCheckoutAddress(_address));
  await c.viewModel.doEvent(
    const SelectCheckoutPayment(CheckoutPaymentMethods.creditCard),
  );
  await c.viewModel.doEvent(const SubmitPlaceOrder());
  await c.viewModel.doEvent(const ClearCheckoutNavigation());
  await c.viewModel.doEvent(const ProcessCheckoutPayment());
  expect(c.viewModel.state.destination, isNull);
  expect(c.viewModel.state.sessionUrl, isNull);
  expect(
    c.viewModel.state.paymentState.errorMessage,
    'Payment checkout failed',
  );
}

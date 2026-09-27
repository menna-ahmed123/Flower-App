import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo/cart_repo.dart';
import 'package:flower_app/features/cart/domain/use_cases/cart_use_cases.dart';
import 'package:flower_app/features/cart/domain/use_cases/checkout_use_cases.dart';
import 'package:flower_app/features/cart/presentation/view/screen/cart_screen.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

const cartRose = CartItemEntity(
  id: 'item-1',
  productId: 'product-1',
  name: 'Red Rose',
  imageUrl: '',
  price: 100,
  quantity: 2,
  stock: 5,
);

CartEntity cartWithItems(List<CartItemEntity> items) {
  return CartEntity(
    id: 'cart-1',
    items: items,
    subtotal: CartEntity.sumLines(items),
    deliveryFee: 0,
    total: CartEntity.sumLines(items),
    itemCount: CartEntity.sumQuantities(items),
  );
}

const checkoutPaymentMethods = [
  PaymentMethodEntity(name: AppString.cashOnDelivery, apiMethod: 'cod'),
  PaymentMethodEntity(
    name: AppString.creditCard,
    apiMethod: 'Card',
    gateway: 'Stripe',
  ),
];

class FakeCartRepo implements CartRepo {
  FakeCartRepo({
    this.getCartResponse = const SuccessResponse(CartEntity.empty()),
    this.detailsResponse = const SuccessResponse(CartEntity.empty()),
    this.placeOrderResponse = const SuccessResponse(
      OrderEntity(status: 'PLACED', paymentMethod: 'COD'),
    ),
    this.paymentResponse = const SuccessResponse(PaymentCheckoutEntity()),
    this.estimateResponse,
  });

  BaseResponse<CartEntity> getCartResponse;
  BaseResponse<CartEntity> detailsResponse;
  BaseResponse<DeliveryEstimateEntity>? estimateResponse;
  BaseResponse<OrderEntity> placeOrderResponse;
  BaseResponse<PaymentCheckoutEntity> paymentResponse;
  Duration placeOrderDelay = Duration.zero;
  Duration getCartDelay = Duration.zero;
  Duration detailsDelay = Duration.zero;
  int getCartCalls = 0;
  int detailsCalls = 0;
  int estimateCalls = 0;
  int placeOrderCalls = 0;
  int paymentCalls = 0;
  String? lastDetailsCartId;
  String? lastEstimateAddressId;
  String? lastEstimateCartId;
  String? lastCartId;
  String? lastAddressId;
  bool? lastIsGift;
  String? lastRecipientName;
  String? lastRecipientPhone;
  String? lastPaymentMethod;
  String? lastPaymentGateway;
  String? lastPaymentOrderId;
  double? lastAmountTotal;
  String? lastCurrency;
  final List<String> idempotencyKeys = [];
  final List<String> removedItemIds = [];

  @override
  Future<BaseResponse<CartEntity>> getCart() async {
    getCartCalls++;
    if (getCartDelay > Duration.zero) {
      await Future<void>.delayed(getCartDelay);
    }
    return getCartResponse;
  }

  @override
  Future<BaseResponse<CartEntity>> addItem({
    required String productId,
    int quantity = 1,
  }) async {
    return const SuccessResponse(CartEntity.empty());
  }

  @override
  Future<BaseResponse<CartEntity>> updateItem({
    required String itemId,
    required int quantity,
  }) async {
    return const SuccessResponse(CartEntity.empty());
  }

  @override
  Future<BaseResponse<CartEntity>> removeItem({required String itemId}) async {
    removedItemIds.add(itemId);
    _dropLine(itemId);
    return getCartResponse;
  }

  void _dropLine(String itemId) {
    final current = getCartResponse;
    if (current is! SuccessResponse<CartEntity>) return;
    final items = [
      for (final item in current.data.items)
        if (item.id != itemId) item,
    ];
    getCartResponse = SuccessResponse(
      items.isEmpty ? const CartEntity.empty() : cartWithItems(items),
    );
  }

  @override
  Future<BaseResponse<CartEntity>> checkoutDetails({
    required String cartId,
  }) async {
    detailsCalls++;
    lastDetailsCartId = cartId;
    if (detailsDelay > Duration.zero) {
      await Future<void>.delayed(detailsDelay);
    }
    return detailsResponse;
  }

  @override
  Future<BaseResponse<DeliveryEstimateEntity>> estimateDelivery({
    required String addressId,
    required String cartId,
  }) async {
    estimateCalls++;
    lastEstimateAddressId = addressId;
    lastEstimateCartId = cartId;
    return estimateResponse ?? const SuccessResponse(DeliveryEstimateEntity());
  }

  @override
  Future<BaseResponse<OrderEntity>> placeOrder({
    required String idempotencyKey,
    required String cartId,
    required String addressId,
    required bool isGift,
    String? recipientName,
    String? recipientPhone,
    required String paymentMethod,
    String? paymentGateway,
  }) async {
    placeOrderCalls++;
    lastCartId = cartId;
    lastAddressId = addressId;
    lastIsGift = isGift;
    lastRecipientName = recipientName;
    lastRecipientPhone = recipientPhone;
    lastPaymentMethod = paymentMethod;
    lastPaymentGateway = paymentGateway;
    idempotencyKeys.add(idempotencyKey);
    if (placeOrderDelay > Duration.zero) {
      await Future<void>.delayed(placeOrderDelay);
    }
    return placeOrderResponse;
  }

  @override
  Future<BaseResponse<PaymentCheckoutEntity>> createPaymentCheckout({
    required String orderId,
    required double amountTotal,
    required String currency,
  }) async {
    paymentCalls++;
    lastPaymentOrderId = orderId;
    lastAmountTotal = amountTotal;
    lastCurrency = currency;
    return paymentResponse;
  }
}

class TestCartViewModel extends CartViewModel {
  TestCartViewModel(CartRepo repo)
    : super(
        GetCartUseCase(repo),
        AddCartItemUseCase(repo),
        UpdateCartItemUseCase(repo),
        RemoveCartItemUseCase(repo),
      );

  void emitState(CartState state) => emit(state);
}

CheckoutViewModel testCheckoutViewModel(CartRepo repo) {
  return CheckoutViewModel(
    PreviewCheckoutUseCase(repo),
    PlaceOrderUseCase(repo),
    ProcessPaymentUseCase(repo),
  );
}

TestCartViewModel testCartViewModel([FakeCartRepo? repo]) {
  return TestCartViewModel(repo ?? FakeCartRepo());
}

Future<void> pumpCartScreen(
  WidgetTester tester,
  CartViewModel viewModel,
) async {
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, _) => BlocProvider<CartViewModel>.value(
        value: viewModel,
        child: MaterialApp(
          theme: AppTheme(lightThemeColors).themeData,
          home: const CartScreen(),
        ),
      ),
    ),
  );
  await tester.pump();
}

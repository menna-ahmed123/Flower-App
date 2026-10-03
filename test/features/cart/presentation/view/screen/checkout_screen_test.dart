import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:flower_app/features/address/domain/use_cases/delete_address_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/set_default_address_use_case.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_address_view_model.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/presentation/view/screen/checkout_screen.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../cart_test_support.dart';

const _address = AddressEntity(id: 'address-1', city: 'Cairo');
const _preview = CartEntity(
  id: 'cart-1',
  items: [],
  subtotal: 100,
  deliveryFee: 0,
  total: 100,
  itemCount: 0,
  paymentMethods: checkoutPaymentMethods,
);

void main() {
  testWidgets('cash place order clears the cart then opens confirmation', (
    tester,
  ) async {
    final env = await _pumpCheckout(
      tester,
      payment: CheckoutPaymentMethods.cashOnDelivery,
      placeOrderResponse: const SuccessResponse(
        OrderEntity(
          orderId: 'order-cash',
          status: 'PLACED',
          paymentMethod: 'COD',
          paymentStatus: 'PENDING',
        ),
      ),
    );
    await tester.tap(find.text(AppString.placeOrder));
    await tester.pumpAndSettle();

    expect(find.text('confirmed:order-cash'), findsOneWidget);
    expect(env.cartRepo.removedItemIds, ['item-1']);
    expect(env.cart.state.itemCount, 0);
    expect(env.cart.state.cartState.data, const CartEntity.empty());
  });

  testWidgets('card place order opens payment and refreshes the cart', (
    tester,
  ) async {
    final env = await _pumpCheckout(
      tester,
      payment: CheckoutPaymentMethods.creditCard,
      placeOrderResponse: const SuccessResponse(
        OrderEntity(
          orderId: 'order-card',
          status: 'PLACED',
          paymentMethod: 'Card',
          paymentStatus: 'PENDING',
        ),
      ),
    );
    await tester.tap(find.text(AppString.placeOrder));
    await tester.pumpAndSettle();

    expect(find.text('payment-page'), findsOneWidget);
    expect(env.cartRepo.removedItemIds, ['item-1']);
    expect(env.cart.state.itemCount, 0);
    expect(env.cart.state.cartState.data, const CartEntity.empty());
  });

  testWidgets('failed place order does not clear the cart', (tester) async {
    final env = await _pumpCheckout(
      tester,
      payment: CheckoutPaymentMethods.cashOnDelivery,
      placeOrderResponse: ErrorResponse(
        appError: BadResponseError(AppString.orderFailed),
      ),
    );
    await tester.tap(find.text(AppString.placeOrder));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(env.cartRepo.placeOrderCalls, 1);
    expect(env.cartRepo.paymentCalls, 0);
    expect(env.cartRepo.removedItemIds, isEmpty);
    expect(env.cart.state.itemCount, 2);
    expect(find.text('confirmed:order-cash'), findsNothing);
    expect(find.text(AppString.orderFailed), findsOneWidget);
  });
}

class _CheckoutEnv {
  _CheckoutEnv({
    required this.cartRepo,
    required this.cart,
    required this.checkout,
    required this.addresses,
    required this.router,
  });

  final FakeCartRepo cartRepo;
  final TestCartViewModel cart;
  final CheckoutViewModel checkout;
  final DefaultAddressViewModel addresses;
  final GoRouter router;

  Future<void> dispose() async {
    await cart.close();
    await checkout.close();
    await addresses.close();
    router.dispose();
  }
}

class _AddressRepo extends Fake implements AddressRepo {}

Future<_CheckoutEnv> _pumpCheckout(
  WidgetTester tester, {
  required String payment,
  required BaseResponse<OrderEntity> placeOrderResponse,
}) async {
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final env = _createEnv(placeOrderResponse);
  addTearDown(env.dispose);
  await env.checkout.doEvent(const LoadCheckoutPreview());
  await env.checkout.doEvent(const SelectCheckoutAddress(_address));
  await env.checkout.doEvent(SelectCheckoutPayment(payment));
  await tester.pumpWidget(_checkoutApp(env));
  await tester.pump();
  return env;
}

_CheckoutEnv _createEnv(BaseResponse<OrderEntity> placeOrderResponse) {
  final cartRepo = FakeCartRepo(
    detailsResponse: const SuccessResponse(_preview),
    placeOrderResponse: placeOrderResponse,
    getCartResponse: SuccessResponse(cartWithItems([cartRose])),
  );
  final cart = testCartViewModel(cartRepo);
  cart.emitState(
    CartState(cartState: BaseState(data: cartWithItems([cartRose]))),
  );
  return _CheckoutEnv(
    cartRepo: cartRepo,
    cart: cart,
    checkout: testCheckoutViewModel(cartRepo),
    addresses: _addresses(),
    router: _router(),
  );
}

DefaultAddressViewModel _addresses() {
  final repo = _AddressRepo();
  return DefaultAddressViewModel(
    GetAddressesUseCase(repo: repo),
    DeleteAddressUseCase(repo: repo),
    SetDefaultAddressUseCase(repo),
  );
}

GoRouter _router() {
  return GoRouter(
    initialLocation: AppRoutesName.checkout,
    routes: [
      GoRoute(
        path: AppRoutesName.checkout,
        builder: (_, _) => const Scaffold(body: CheckoutBody()),
      ),
      GoRoute(
        path: AppRoutesName.confirmation,
        builder: (_, state) => Text('confirmed:${state.extra}'),
      ),
      GoRoute(
        path: AppRoutesName.payment,
        builder: (_, _) => const Text('payment-page'),
      ),
    ],
  );
}

Widget _checkoutApp(_CheckoutEnv env) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (_, _) => MultiBlocProvider(
      providers: [
        BlocProvider<CartViewModel>.value(value: env.cart),
        BlocProvider<CheckoutViewModel>.value(value: env.checkout),
        BlocProvider<DefaultAddressViewModel>.value(value: env.addresses),
      ],
      child: MaterialApp.router(
        theme: AppTheme(lightThemeColors).themeData,
        routerConfig: env.router,
      ),
    ),
  );
}

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo/cart_repo.dart';
import 'package:flower_app/features/cart/domain/use_cases/cart_use_case.dart';
import 'package:flower_app/features/cart/presentation/view/screen/cart_screen.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
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
    deliveryFee: 10,
    total: CartEntity.sumLines(items) + 10,
    itemCount: CartEntity.sumQuantities(items),
  );
}

class FakeCartRepo implements CartRepo {
  FakeCartRepo({
    this.getCartResponse = const SuccessResponse(CartEntity.empty()),
    this.placeOrderResponse = const SuccessResponse(true),
    this.paymentResponse = const SuccessResponse(true),
  });

  BaseResponse<CartEntity> getCartResponse;
  BaseResponse<bool> placeOrderResponse;
  BaseResponse<bool> paymentResponse;
  Duration placeOrderDelay = Duration.zero;
  int getCartCalls = 0;
  int placeOrderCalls = 0;
  int paymentCalls = 0;

  @override
  Future<BaseResponse<CartEntity>> getCart() async {
    getCartCalls++;
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
  Future<BaseResponse<bool>> removeItem({required String itemId}) async {
    return const SuccessResponse(true);
  }

  @override
  Future<BaseResponse<bool>> placeOrder() async {
    placeOrderCalls++;
    if (placeOrderDelay > Duration.zero) {
      await Future<void>.delayed(placeOrderDelay);
    }
    return placeOrderResponse;
  }

  @override
  Future<BaseResponse<bool>> processPayment() async {
    paymentCalls++;
    return paymentResponse;
  }
}

class TestCartViewModel extends CartViewModel {
  TestCartViewModel(super.useCase);

  void emitState(CartState state) => emit(state);
}

TestCartViewModel testCartViewModel([FakeCartRepo? repo]) {
  return TestCartViewModel(CartUseCase(repo ?? FakeCartRepo()));
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

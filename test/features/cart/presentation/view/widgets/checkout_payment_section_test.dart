import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/checkout_payment_section.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../cart_test_support.dart';

void main() {
  testWidgets('renders payment methods returned by checkout details', (
    tester,
  ) async {
    await _pumpPayment(
      tester,
      FakeCartRepo(
        getCartResponse: const SuccessResponse(
          CartEntity(
            id: 'cart-1',
            items: [cartRose],
            subtotal: 100,
            deliveryFee: 0,
            total: 100,
            itemCount: 1,
          ),
        ),
        detailsResponse: const SuccessResponse(
          CartEntity(
            id: 'cart-1',
            items: [],
            subtotal: 100,
            deliveryFee: 0,
            total: 100,
            itemCount: 0,
            paymentMethods: [
              PaymentMethodEntity(name: 'Wallet', apiMethod: 'Wallet'),
              PaymentMethodEntity(name: 'Visa', apiMethod: 'Visa'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Wallet'), findsOneWidget);
    expect(find.text('Visa'), findsOneWidget);
    expect(find.text(AppString.cashOnDelivery), findsNothing);
    expect(find.text(AppString.creditCard), findsNothing);
  });

  testWidgets('does not invent payment methods when details fail', (
    tester,
  ) async {
    await _pumpPayment(
      tester,
      FakeCartRepo(
        getCartResponse: const SuccessResponse(
          CartEntity(
            id: 'cart-1',
            items: [cartRose],
            subtotal: 100,
            deliveryFee: 0,
            total: 100,
            itemCount: 1,
          ),
        ),
        detailsResponse: ErrorResponse(
          appError: BadResponseError('Resource not found.'),
        ),
      ),
    );

    expect(find.text(AppString.cashOnDelivery), findsNothing);
    expect(find.text(AppString.creditCard), findsNothing);
  });
}

Future<void> _pumpPayment(WidgetTester tester, FakeCartRepo repo) async {
  final viewModel = testCheckoutViewModel(repo);
  addTearDown(viewModel.close);
  await viewModel.doEvent(const LoadCheckoutPreview());
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_paymentApp(viewModel));
  await tester.pump();
}

Widget _paymentApp(CheckoutViewModel viewModel) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (_, _) => BlocProvider.value(
      value: viewModel,
      child: MaterialApp(
        theme: AppTheme(lightThemeColors).themeData,
        home: const Scaffold(body: CheckoutPaymentSection()),
      ),
    ),
  );
}

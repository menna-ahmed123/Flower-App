import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/cart/presentation/view/screen/confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('Track Order passes the order id', (tester) async {
    await _pumpConfirmation(tester, orderId: 'order-1');

    await tester.tap(find.text(AppString.trackOrder));
    await tester.pumpAndSettle();

    expect(find.text('track:order-1'), findsOneWidget);
  });

  testWidgets('system back goes home instead of popping', (tester) async {
    await _pumpConfirmation(tester, orderId: 'order-1');

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('home-page'), findsOneWidget);
  });
}

Future<void> _pumpConfirmation(WidgetTester tester, {String? orderId}) async {
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: AppRoutesName.confirmation,
    routes: [
      GoRoute(
        path: AppRoutesName.home,
        builder: (_, _) => const Text('home-page'),
      ),
      GoRoute(
        path: AppRoutesName.confirmation,
        builder: (_, _) => ConfirmationScreen(orderId: orderId),
      ),
      GoRoute(
        path: AppRoutesName.trackOrder,
        builder: (_, state) => Text('track:${state.extra}'),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, _) => MaterialApp.router(
        theme: AppTheme(lightThemeColors).themeData,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

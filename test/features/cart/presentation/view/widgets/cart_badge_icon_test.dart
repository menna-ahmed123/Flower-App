import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/cart_badge_icon.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../cart_test_support.dart';

void main() {
  late TestCartViewModel viewModel;

  setUp(() {
    viewModel = testCartViewModel();
  });

  tearDown(() async {
    await viewModel.close();
  });

  testWidgets('hides the badge when the cart is empty', (tester) async {
    await _pumpBadge(tester, viewModel);

    final badge = tester.widget<Badge>(find.byType(Badge));
    expect(badge.isLabelVisible, isFalse);
    expect(find.text('0'), findsNothing);
    expect(find.byIcon(AppIcons.shoppingCart), findsOneWidget);
  });

  testWidgets('shows the badge count when the cart has items', (tester) async {
    viewModel.emitState(
      CartState(cartState: BaseState(data: cartWithItems([cartRose]))),
    );
    await _pumpBadge(tester, viewModel);

    final badge = tester.widget<Badge>(find.byType(Badge));
    expect(badge.isLabelVisible, isTrue);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('0'), findsNothing);
    expect(find.byIcon(AppIcons.shoppingCart), findsOneWidget);
  });
}

Future<void> _pumpBadge(WidgetTester tester, CartViewModel viewModel) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, _) => BlocProvider<CartViewModel>.value(
        value: viewModel,
        child: MaterialApp(
          theme: AppTheme(lightThemeColors).themeData,
          home: const Scaffold(body: Center(child: CartBadgeIcon())),
        ),
      ),
    ),
  );
  await tester.pump();
}

import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/auth/register/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/auth/register/support/register_test_support.dart';

void main() {
  registerPageSmokeTest();
}

void registerPageSmokeTest() {
  testWidgets('Register page loads sign up screen', (tester) async {
    await pumpRegisterSmokePage(tester);
    expect(find.widgetWithText(ElevatedButton, 'Sign up'), findsOneWidget);
  });
}

Future<void> pumpRegisterSmokePage(WidgetTester tester) async {
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        theme: AppTheme(lightThemeColors).themeData,
        home: RegisterPage(
          createBloc: testRegisterBlocFactory(FakeRegisterRepository()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

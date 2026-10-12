import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps [child] the way the real app does: ScreenUtil + MaterialApp + the
/// app's own light theme (AppTheme), so `context.colors`, button styles and
/// text styles are the real ones.
///
/// The theme is built INSIDE the ScreenUtilInit builder because AppTheme uses
/// `.w` / `.sp`, which need ScreenUtil to be initialised first.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  ThemeData? theme,
  Size size = const Size(375, 812),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MaterialApp(
        theme: theme ?? AppTheme(lightThemeColors).themeData,
        home: child,
      ),
    ),
  );
  // NOT pumpAndSettle: several widgets loop animations forever.
  await tester.pump();
}

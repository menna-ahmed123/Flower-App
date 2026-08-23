import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

HomeSectionDto sectionDto({
  required String type,
  required String id,
  String title = '',
  int order = 0,
  bool enabled = true,
  Map<String, dynamic> payload = const {},
}) {
  return HomeSectionDto(
    type: type,
    id: id,
    title: title,
    order: order,
    enabled: enabled,
    payload: payload,
  );
}

HomeSectionEntity sectionEntity({
  required String type,
  required String id,
  String title = '',
  int order = 0,
  String viewAllDeepLink = '',
  List<HomeRailItemEntity> items = const [],
}) {
  return HomeSectionEntity(
    type: type,
    id: id,
    title: title,
    order: order,
    imageUrl: '',
    deepLink: '',
    viewAllLabel: 'View All',
    viewAllDeepLink: viewAllDeepLink,
    items: items,
  );
}

HomeRailItemEntity railItem(String name) {
  return HomeRailItemEntity(id: name, name: name, imageUrl: '', deepLink: '');
}

void ignoreOverflowErrors() {
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('A RenderFlex overflowed')) {
      return;
    }
    originalOnError?.call(details);
  };
  addTearDown(() => FlutterError.onError = originalOnError);
}

Future<void> pumpThemed(WidgetTester tester, Widget child) async {
  ignoreOverflowErrors();
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        theme: AppTheme(lightThemeColors).themeData,
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pump();
}

Future<void> pumpRouted(WidgetTester tester, GoRouter router) async {
  ignoreOverflowErrors();
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp.router(
        theme: AppTheme(lightThemeColors).themeData,
        routerConfig: router,
      ),
    ),
  );
  await tester.pump();
}

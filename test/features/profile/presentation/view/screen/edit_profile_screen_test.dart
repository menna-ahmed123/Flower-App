import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/profile/presentation/view/screen/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Future<void> pumpSized(WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets(
    'shows the Edit Profile title, an empty body and no form fields yet',
    (tester) async {
      await pumpSized(tester);

      final router = GoRouter(
        initialLocation: '/profile',
        routes: [
          GoRoute(path: '/profile', builder: (_, _) => const Text('PROFILE')),
          GoRoute(
            path: '/edit-profile',
            builder: (_, _) => const EditProfileScreen(),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) => MaterialApp.router(
            theme: AppTheme(lightThemeColors).themeData,
            routerConfig: router,
          ),
        ),
      );
      router.push('/edit-profile');
      await tester.pumpAndSettle();

      expect(find.text(AppString.editProfile), findsOneWidget);
      // The real Edit Profile business logic (form, validation, update
      // API) was intentionally removed and isn't implemented yet; this
      // screen is still a placeholder, so there should be no input
      // fields or save action to assert on.
      expect(find.byType(TextField), findsNothing);
      expect(find.byType(TextFormField), findsNothing);
    },
  );

  testWidgets('tapping the back icon pops back to the previous screen', (
    tester,
  ) async {
    await pumpSized(tester);

    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(path: '/profile', builder: (_, _) => const Text('PROFILE')),
        GoRoute(
          path: '/edit-profile',
          builder: (_, _) => const EditProfileScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) => MaterialApp.router(
          theme: AppTheme(lightThemeColors).themeData,
          routerConfig: router,
        ),
      ),
    );
    router.push('/edit-profile');
    await tester.pumpAndSettle();

    // Exercises the real back button (CustomAppBar's onBack callback),
    // not just router.pop() called directly from the test.
    await tester.tap(find.byIcon(AppIcons.arrowBack));
    await tester.pumpAndSettle();

    expect(find.text('PROFILE'), findsOneWidget);
  });

  testWidgets(
    'tapping the back icon with nothing to pop navigates to the profile route',
    (tester) async {
      await pumpSized(tester);

      final router = GoRouter(
        initialLocation: '/edit-profile',
        routes: [
          GoRoute(path: '/profile', builder: (_, _) => const Text('PROFILE')),
          GoRoute(
            path: '/edit-profile',
            builder: (_, _) => const EditProfileScreen(),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) => MaterialApp.router(
            theme: AppTheme(lightThemeColors).themeData,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(AppIcons.arrowBack));
      await tester.pumpAndSettle();

      expect(find.text('PROFILE'), findsOneWidget);
    },
  );
}

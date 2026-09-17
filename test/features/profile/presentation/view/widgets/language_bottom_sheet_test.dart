import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/language_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await EasyLocalization.ensureInitialized();
  });

  Future<BuildContext> pumpHost(WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    late BuildContext hostContext;

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        useOnlyLangCode: true,
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) => MaterialApp(
            theme: AppTheme(lightThemeColors).themeData,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: Builder(
              builder: (context) {
                hostContext = context;
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () => LanguageBottomSheet.show(context),
                    child: const Text('open'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    return hostContext;
  }

  testWidgets('shows both language options', (tester) async {
    await pumpHost(tester);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text(AppString.changeLanguage), findsOneWidget);
    expect(find.text(AppString.arabicLanguage), findsOneWidget);
    expect(find.text(AppString.englishLanguage), findsOneWidget);
  });

  testWidgets(
    'tapping the Arabic option sets the app locale to Arabic and closes',
    (tester) async {
      final hostContext = await pumpHost(tester);
      expect(hostContext.locale.languageCode, 'en');

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppString.arabicLanguage));
      await tester.pumpAndSettle();

      expect(hostContext.locale.languageCode, 'ar');
      expect(find.text(AppString.changeLanguage), findsNothing);
    },
  );
}

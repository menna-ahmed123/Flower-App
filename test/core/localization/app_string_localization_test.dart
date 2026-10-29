import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('arabic locale translates the ui and lays out right to left', (
    tester,
  ) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('ar'),
        useOnlyLangCode: true,
        child: Builder(
          builder: (context) {
            return MaterialApp(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home: const Scaffold(body: _LocalizedProbe()),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('سلتك فارغة'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('تسجيل الدخول'))),
      TextDirection.rtl,
    );
  });
}

class _LocalizedProbe extends StatelessWidget {
  const _LocalizedProbe();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(AppString.login), Text(AppString.cartIsEmpty)],
    );
  }
}

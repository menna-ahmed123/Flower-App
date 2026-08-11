import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/localization/localization.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt<LocaleController>().load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.localeController});

  final LocaleController? localeController;

  @override
  Widget build(BuildContext context) {
    final controller = localeController ?? getIt<LocaleController>();

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return MaterialApp(
              theme: AppTheme(LightThemeColor()).themeData,
              darkTheme: AppTheme(DarkThemeColor()).themeData,
              debugShowCheckedModeBanner: false,
              locale: controller.locale,
              supportedLocales: AppLocales.supportedLocales,
              localeResolutionCallback: AppLocales.localeResolutionCallback,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        );
      },
    );
  }
}

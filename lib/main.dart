import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/localization/localization.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'app/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  await getIt<LocaleController>().load();

  final initialLocation = await AppRouter.resolveInitialLocation();

  runApp(MyApp(initialLocation: initialLocation));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.localeController, this.initialLocation});

  final LocaleController? localeController;
  final String? initialLocation;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router = AppRouter.createRouter(
    initialLocation: widget.initialLocation,
  );

  @override
  Widget build(BuildContext context) {
    final controller = widget.localeController ?? getIt<LocaleController>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return MaterialApp.router(
              routerConfig: _router,
              theme: AppTheme(LightThemeColor()).themeData,
              darkTheme: AppTheme(DarkThemeColor()).themeData,
              debugShowCheckedModeBanner: false,
              locale: controller.resolvedLocale,
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

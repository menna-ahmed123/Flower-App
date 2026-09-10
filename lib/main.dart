import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'app/router/app_router.dart';
import 'core/auth/presentation/view_model/auth_cubit.dart';
import 'core/auth/presentation/view_model/auth_event.dart';
import 'features/cart/presentation/view_model/cart_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env', isOptional: true);
  await ApiEndpoints.loadBaseUrl();
  await configureDependencies();
  await EasyLocalization.ensureInitialized();

  final initialLocation = await AppRouter.resolveInitialLocation();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: MyApp(initialLocation: initialLocation),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialLocation});

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<AuthCubit>()..doEvent(const AuthEvent.authCheckRequested()),
        ),
        BlocProvider.value(value: getIt<CartViewModel>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            routerConfig: _router,
            theme: AppTheme(LightThemeColor()).themeData,
            darkTheme: AppTheme(DarkThemeColor()).themeData,
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
          );
        },
      ),
    );
  }
}

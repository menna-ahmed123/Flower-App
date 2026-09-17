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
import 'core/auth/auth_session_controller.dart';
import 'features/auth/core/presentation/view_model/auth_cubit.dart';
import 'features/auth/core/presentation/view_model/auth_event.dart';
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

  // Created once and shared as both the concrete AuthCubit (for screens that
  // need its full state, e.g. Home) and the narrower AuthSessionController
  // (for features like Profile that only need to trigger a logout without
  // depending on the Auth feature's own presentation layer).
  late final AuthCubit _authCubit = getIt<AuthCubit>()
    ..doEvent(const AuthEvent.authCheckRequested());

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthSessionController>.value(value: _authCubit),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: _authCubit),
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
      ),
    );
  }
}

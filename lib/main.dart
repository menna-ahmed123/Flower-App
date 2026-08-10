import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/router/app_router.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: appRouter,
          theme: AppTheme(LightThemeColor()).themeData,
          darkTheme: AppTheme(DarkThemeColor()).themeData,
         debugShowCheckedModeBanner: false,                 
        );
      },
    );
  }
}
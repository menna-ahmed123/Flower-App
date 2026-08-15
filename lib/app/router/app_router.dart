import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/features/auth/forgetPassword/forget_password.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login/presentation/view/pages/login_page.dart';
import '../../features/auth/register/presentation/pages/register_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutesName.login,
      errorBuilder: (context, state) {
        return const Scaffold(
          body: Center(
            child: Text('Page Not Found'),
          ),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutesName.login,
           builder: (context, state) => BlocProvider(
          create: (_) => getIt<LoginViewModel>(),
          child: const LoginPage(),
        ),
        ),
        GoRoute(
          path: AppRoutesName.register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: AppRoutesName.forgetPassword,
          builder: (context, state) => const ForgetPassword(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return navigationShell;
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutesName.home,
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutesName.categories,
                  builder: (context, state) => const CategoriesPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutesName.cart,
                  builder: (context, state) => const CartPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutesName.profile,
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

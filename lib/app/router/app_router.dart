import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/features/auth/login/presentation/pages/login_page.dart';
import 'package:flower_app/features/auth/register/presentation/pages/register_page.dart';
import 'package:flower_app/features/cart/presentation/pages/cart_page.dart';
import 'package:flower_app/features/categories/presentation/pages/categories_page.dart';
import 'package:flower_app/features/forget_password/presentation/pages/forget_password_page.dart';
import 'package:flower_app/features/forget_password/presentation/pages/verification_page.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_cubit.dart';
import 'package:flower_app/features/home/presentation/pages/home_page.dart';
import 'package:flower_app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
abstract final class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutesName.forgetPassword,
      errorBuilder: _errorBuilder,
      routes: [
        _loginRoute(),
        _registerRoute(),
        _forgetPasswordShell(),
        _mainShell(),
      ],
    );
  }

  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return const Scaffold(body: Center(child: Text('Page Not Found')));
  }

  static GoRoute _loginRoute() {
    return GoRoute(
      path: AppRoutesName.login,
      builder: (context, state) => const LoginPage(),
    );
  }

  static GoRoute _registerRoute() {
    return GoRoute(
      path: AppRoutesName.register,
      builder: (context, state) => const RegisterPage(),
    );
  }

  static ShellRoute _forgetPasswordShell() {
    return ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => getIt<ForgetPasswordCubit>(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutesName.forgetPassword,
          builder: (context, state) => const ForgetPasswordPage(),
          routes: [
            GoRoute(
              path: AppRoutesName.verification,
              builder: (context, state) => const VerificationPage(),
            ),
          ],
        ),
      ],
    );
  }

  static StatefulShellRoute _mainShell() {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => navigationShell,
      branches: [
        _homeBranch(),
        _categoriesBranch(),
        _cartBranch(),
        _profileBranch(),
      ],
    );
  }

  static StatefulShellBranch _homeBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.home,
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
  }

  static StatefulShellBranch _categoriesBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.categories,
          builder: (context, state) => const CategoriesPage(),
        ),
      ],
    );
  }

  static StatefulShellBranch _cartBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.cart,
          builder: (context, state) => const CartPage(),
        ),
      ],
    );
  }

  static StatefulShellBranch _profileBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.profile,
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    );
  }
}

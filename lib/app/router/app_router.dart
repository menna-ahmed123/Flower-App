import 'package:flower_app/app/layout/main_shell.dart';
import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/navigation/route_success_snack_bar.dart';
import 'package:flower_app/core/network/token_storage.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/login_page.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_view_model.dart';
import 'package:flower_app/features/auth/register/presentation/view/pages/register_page.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_view_model.dart';
import 'package:flower_app/features/cart/presentation/pages/cart_page.dart';
import 'package:flower_app/features/categories/presentation/pages/categories_page.dart';
import 'package:flower_app/features/auth/forget_password/presentation/pages/forget_password_page.dart';
import 'package:flower_app/features/auth/forget_password/presentation/pages/reset_password_page.dart';
import 'package:flower_app/features/auth/forget_password/presentation/pages/verification_page.dart';
import 'package:flower_app/features/auth/forget_password/presentation/view_model/forget_password_cubit.dart';
import 'package:flower_app/features/home/presentation/pages/home_page.dart';
import 'package:flower_app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Future<String> resolveInitialLocation() async {
    final isAuthenticated = await _hasSession();
    return isAuthenticated ? AppRoutesName.home : AppRoutesName.login;
  }

  static GoRouter createRouter({String? initialLocation}) {
    return GoRouter(
      initialLocation: initialLocation ?? AppRoutesName.login,
      redirect: _redirect,
      errorBuilder: _errorBuilder,
      routes: [
        _loginRoute(),
        _registerRoute(),
        _forgetPasswordShell(),
        _mainShell(),
      ],
    );
  }

  static Future<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final isLoginRoute = state.matchedLocation == AppRoutesName.login;
    if (!isLoginRoute) {
      return null;
    }

    final isAuthenticated = await _hasSession();
    if (isAuthenticated) {
      return AppRoutesName.home;
    }

    return null;
  }

  static Future<bool> _hasSession() async {
    final token = await getIt<TokenStorage>().getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return const Scaffold(body: Center(child: Text('Page Not Found')));
  }

  static GoRoute _loginRoute() {
    return GoRoute(
      path: AppRoutesName.login,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => getIt<LoginViewModel>(),
          child: RouteSuccessSnackBar(
            message: state.uri.queryParameters['success'],
            child: const LoginPage(),
          ),
        );
      },
    );
  }

  static GoRoute _registerRoute() {
    return GoRoute(
      path: AppRoutesName.register,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => getIt<RegisterViewModel>(),
          child: const RegisterPage(),
        );
      },
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
          builder: (context, state) {
            return const ForgetPasswordPage();
          },
          routes: [
            GoRoute(
              path: AppRoutesName.verification,
              builder: (context, state) {
                return const VerificationPage();
              },
            ),
            GoRoute(
              path: AppRoutesName.resetPassword,
              builder: (context, state) {
                return const ResetPasswordPage();
              },
            ),
          ],
        ),
      ],
    );
  }

  static StatefulShellRoute _mainShell() {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
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

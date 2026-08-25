import 'package:flower_app/app/layout/main_shell.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/navigation/route_success_snack_bar.dart';
import 'package:flower_app/core/network/token_storage.dart';
import 'package:flower_app/features/auth/forget_password/presentation/pages/forget_password_page.dart';
import 'package:flower_app/features/auth/forget_password/presentation/pages/reset_password_page.dart';
import 'package:flower_app/features/auth/forget_password/presentation/pages/verification_page.dart';
import 'package:flower_app/features/auth/forget_password/presentation/view_model/forget_password_cubit.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/login_page.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_view_model.dart';
import 'package:flower_app/features/auth/register/presentation/view/pages/register_page.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_view_model.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view/screen/best_seller_screen.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_view_model.dart';
import 'package:flower_app/features/commerce/presentation/category/view/screen/category_screen.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_event.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_view_model.dart';
import 'package:flower_app/features/commerce/presentation/home/view/screen/home_screen.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_view_model.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view/screen/occasion_screen.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view_model/occasion_view_model.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view/screen/product_details_screen.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view_model/product_details_event.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view_model/product_details_view_model.dart';
import 'package:flower_app/features/orders/presentation/view/screen/cart_screen.dart';
import 'package:flower_app/features/profile/presentation/view/screen/profile_screen.dart';
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

        GoRoute(
          path: AppRoutesName.bestSeller,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<BestSellerViewModel>(),
            child: const BestSellerScreen(),
          ),
        ),

        GoRoute(
          path: AppRoutesName.occasion,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<OccasionViewModel>(),
            child: const OccasionScreen(),
          ),
        ),

        GoRoute(
          path: AppRoutesName.productDetails,
          builder: (context, state) {
            final productId = state.pathParameters['productId']!;

            return BlocProvider(
              create: (_) =>
                  getIt<ProductDetailsViewModel>()
                    ..onEvent(GetProductDetailsEvent(productId: productId)),
              child: const ProductDetailsScreen(),
            );
          },
        ),
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
    return const Scaffold(body: Center(child: Text(AppString.pageNotFound)));
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
        categoryBranch(),
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
          builder: _homeBuilder,
        ),
      ],
    );
  }

  static Widget _homeBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => getIt<HomeViewModel>()..doEvent(HomeRequested()),
      child: const HomeScreen(),
    );
  }

  static StatefulShellBranch categoryBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.category,
          builder: (context, state) => BlocProvider(
            create: (_) =>
                getIt<CategoryViewModel>()..onEvent(LoadCategories()),
            child: const CategoryScreen(),
          ),
        ),
      ],
    );
  }

  static StatefulShellBranch _cartBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.cart,
          builder: (context, state) {
            return const CartScreen();
          },
        ),
      ],
    );
  }

  static StatefulShellBranch _profileBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.profile,
          builder: (context, state) {
            return const ProfileScreen();
          },
        ),
      ],
    );
  }
}

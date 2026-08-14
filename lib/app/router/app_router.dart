import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/navigation/route_success_snack_bar.dart';
import 'package:flower_app/features/auth/login/presentation/pages/login_page.dart';
import 'package:flower_app/features/auth/register/presentation/pages/register_page.dart';
import 'package:flower_app/features/cart/presentation/pages/cart_page.dart';
import 'package:flower_app/features/categories/presentation/pages/categories_page.dart';
import 'package:flower_app/features/home/presentation/pages/home_page.dart';
import 'package:flower_app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutesName.register,
      errorBuilder: errorPage,
      routes: [...authRoutes, shellRoute],
    );
  }

  static Widget errorPage(BuildContext context, GoRouterState state) {
    return const Scaffold(
      body: Center(child: Text('Page Not Found')),
    );
  }

  static List<RouteBase> get authRoutes {
    return [loginRoute, registerRoute];
  }

  static GoRoute get loginRoute {
    return GoRoute(
      path: AppRoutesName.login,
      builder: (context, state) => RouteSuccessSnackBar(
        message: state.uri.queryParameters['success'],
        child: const LoginPage(),
      ),
    );
  }

  static GoRoute get registerRoute {
    return GoRoute(
      path: AppRoutesName.register,
      builder: (context, state) => const RegisterPage(),
    );
  }

  static StatefulShellRoute get shellRoute {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => navigationShell,
      branches: shellBranches,
    );
  }

  static List<StatefulShellBranch> get shellBranches {
    return [homeBranch, categoriesBranch, cartBranch, profileBranch];
  }

  static StatefulShellBranch get homeBranch {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.home,
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
  }

  static StatefulShellBranch get categoriesBranch {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.categories,
          builder: (context, state) => const CategoriesPage(),
        ),
      ],
    );
  }

  static StatefulShellBranch get cartBranch {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.cart,
          builder: (context, state) => const CartPage(),
        ),
      ],
    );
  }

  static StatefulShellBranch get profileBranch {
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

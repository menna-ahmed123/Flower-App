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

import '../../features/forget_password/presentation/pages/reset_password_page.dart';
import 'app_routes.dart';

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutesName.forgetPassword,
      errorBuilder: (context, state) {
        return const Scaffold(body: Center(child: Text('Page Not Found')));
      },
      routes: [
        GoRoute(
          path: AppRoutesName.categories,
          builder: (context, state) => const CategoriesPage(),
        ),

        GoRoute(
          path: AppRoutesName.forgetPassword,
          builder: (context, state) => const ForgetPassword(),
        ),

        ShellRoute(
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
                  builder: (context, state) => const ResetPasswordPage(),
                ),
              ],
            ),
          ],
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

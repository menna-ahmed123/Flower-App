import 'package:flower_app/core/auth/auth_extension.dart';
import 'package:flower_app/core/auth/presentation/view/auth_bottom_sheet.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_cubit.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_state.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/cart_badge_icon.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
      !previous.requiresAuthentication &&
          current.requiresAuthentication,
      listener: (context, state) {
        showLoginBottomSheet(context);
      },
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            previous.isAuthenticated != current.isAuthenticated,
        listener: (context, state) {
          final cart = context.read<CartViewModel>();
          if (state.isAuthenticated) {
            cart.doEvent(LoadCart());
            return;
          }
          cart.doEvent(ResetCart());
        },
        child: BlocListener<CartViewModel, CartState>(
          listenWhen: (previous, current) =>
              previous.cartState.errorMessage !=
                  current.cartState.errorMessage &&
              current.cartState.errorMessage.isNotEmpty,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.cartState.errorMessage)),
            );
          },
          child: Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) async {
                final isProtectedRoute = index == 2 || index == 3;

                if (isProtectedRoute) {
                  await context.requireAuth(
                    action: () async {
                      navigationShell.goBranch(
                        index,
                        initialLocation: false,
                      );
                      if (index == 2) {
                        await context.read<CartViewModel>().doEvent(LoadCart());
                      }
                    },
                  );

                  return;
                }

                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(AppIcons.home),
                  label: AppString.home,
                ),
                NavigationDestination(
                  icon: Icon(AppIcons.storefront),
                  label: AppString.categories,
                ),
                NavigationDestination(
                  icon: CartBadgeIcon(),
                  label: AppString.cart,
                ),
                NavigationDestination(
                  icon: Icon(AppIcons.person),
                  label: AppString.profile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

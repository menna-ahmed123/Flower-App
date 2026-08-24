import 'package:flower_app/core/auth/presentation/view/auth_bottom_sheet.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/presentation/view_model/auth_cubit.dart';
import '../../core/auth/presentation/view_model/auth_event.dart';
import '../../core/auth/presentation/view_model/auth_state.dart';

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
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) async {
                final authCubit = context.read<AuthCubit>();
                final isAuthenticated = authCubit.state.isAuthenticated;

                final isProtectedRoute = index == 2 || index == 3;

                if (isProtectedRoute && !isAuthenticated) {
                  await authCubit.doEvent(
                    AuthEvent.authAuthenticationRequired(
                      pendingAction: () async {
                        navigationShell.goBranch(
                          index,
                          initialLocation: false,
                        );
                      },
                    ),
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
                  icon: Icon(AppIcons.shoppingCart),
                  label: AppString.cart,
                ),
                NavigationDestination(
                  icon: Icon(AppIcons.person),
                  label: AppString.profile,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
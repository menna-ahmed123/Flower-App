import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/presentation/view_model/auth_cubit.dart';
import '../../core/auth/presentation/view_model/auth_state.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isAuthenticated = state.authState.data ?? false;

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(AppIcons.home),
                label: AppString.home,
              ),
              const NavigationDestination(
                icon: Icon(AppIcons.storefront),
                label: AppString.categories,
              ),
              if (isAuthenticated)
                const NavigationDestination(
                  icon: Icon(AppIcons.shoppingCart),
                  label: AppString.cart,
                ),
              if (isAuthenticated)
                const NavigationDestination(
                  icon: Icon(AppIcons.person),
                  label: AppString.profile,
                ),
            ],
          ),
        );
      },
    );
  }
}
import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../view_model/auth_cubit.dart';
import '../view_model/auth_event.dart';
import '../view_model/auth_state.dart';

Future<void> showLoginBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    showDragHandle: false,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppString.login,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8.h),
            const Text(AppString.loginToContinue),
            SizedBox(height: 24.h),
            AppButton(
              text: AppString.login,
              onPressed: () async {
                Navigator.of(context).pop();

                await context.push(AppRoutesName.login);

                if (!context.mounted) return;

                final authCubit = context.read<AuthCubit>();

                if (!authCubit.state.isAuthenticated) {
                  await authCubit.doEvent(
                    const AuthAuthenticationCancelled(),
                  );
                }
              },
            ),
            SizedBox(height: 12.h),
            AppButton(
              variant: AppButtonVariant.outlined,
              text: AppString.signUp,
              onPressed: () async {
                Navigator.of(context).pop();

                await context.push(AppRoutesName.register);

                if (!context.mounted) return;

                final authCubit = context.read<AuthCubit>();

                if (!authCubit.state.isAuthenticated) {
                  await authCubit.doEvent(
                    const AuthAuthenticationCancelled(),
                  );
                }
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      );
    },
  );
}
import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_cubit.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_event.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthCubit>().doEvent(const AuthLogoutRequested());
    if (!context.mounted) {
      return;
    }
    context.go(AppRoutesName.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.profile)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            AppButton(
              text: AppString.logout,
              onPressed: () => _logout(context),
            ),

            SizedBox(height: 15.h),
             AppButton(
              text: AppString.savedAddresses,
              onPressed: (){
                context.go(AppRoutesName.saveAddress);}
            ),
          ],
        ),
      ),
    );
  }
}

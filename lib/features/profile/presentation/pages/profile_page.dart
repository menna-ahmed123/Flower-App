import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/auth/login/domain/use_case/logout_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await getIt<LogoutUseCase>()();
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
        child: AppButton(
          text: AppString.logout,
          onPressed: () => _logout(context),
        ),
      ),
    );
  }
}

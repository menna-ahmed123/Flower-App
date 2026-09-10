import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/auth/core/presentation/view_model/auth_cubit.dart';
import 'package:flower_app/features/auth/core/presentation/view_model/auth_event.dart';
import 'package:flower_app/features/profile/presentation/models/profile_display_data.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/language_bottom_sheet.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/logout_confirmation_dialog.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_header.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_info_section.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_options_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Local UI-only toggle: no notification-preferences state/API exists yet.
  bool _notificationsEnabled = true;

  void _onNotificationsChanged(bool value) {
    setState(() => _notificationsEnabled = value);
  }

  Future<void> _onLanguageTap() {
    return LanguageBottomSheet.show(context);
  }

  Future<void> _onLogoutTap() async {
    final confirmed = await LogoutConfirmationDialog.show(context);
    if (!confirmed || !mounted) {
      return;
    }

    await context.read<AuthCubit>().doEvent(const AuthLogoutRequested());
    if (!mounted) {
      return;
    }
    context.go(AppRoutesName.login);
  }

  void _onSavedAddressTap() {
    context.push(AppRoutesName.saveAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: ProfileInfoSection(data: ProfileDisplayData.mock),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ProfileOptionsSection(
                  notificationsEnabled: _notificationsEnabled,
                  onNotificationsChanged: _onNotificationsChanged,
                  onSavedAddressTap: _onSavedAddressTap,
                  onLanguageTap: _onLanguageTap,
                  onLogoutTap: _onLogoutTap,
                  // My orders, About us and Terms & conditions have no
                  // destination in the app yet; left as integration points.
                ),
              ),
              SizedBox(height: 24.h),
              Center(
                child: Text(
                  AppString.appVersion,
                  style: TextStyle(
                    color: context.colors.grey.shade900,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/auth/auth_session_controller.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/constants/app_urls.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_web_view_screen.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/language_bottom_sheet.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/logout_confirmation_dialog.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_header.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_info_section.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_options_section.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_state.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_view_model.dart';
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
  @override
  void initState() {
    super.initState();
    // The View always asks to be initialized; the ViewModel decides
    // whether a network call is actually needed.
    context.read<ProfileViewModel>().doEvent(ProfileInitialized());
  }

  void _onNotificationsChanged(bool value) {
    context.read<ProfileViewModel>().doEvent(
      NotificationToggleChanged(value),
    );
  }

  Future<void> _onLanguageTap() {
    return LanguageBottomSheet.show(context);
  }

  Future<void> _onLogoutTap() async {
    final confirmed = await LogoutConfirmationDialog.show(context);
    if (!confirmed || !mounted) {
      return;
    }

    await context.read<AuthSessionController>().logout();
    if (!mounted) {
      return;
    }
    context.go(AppRoutesName.login);
  }

  void _onSavedAddressTap() {
    context.push(AppRoutesName.saveAddress);
  }

  void _onEditProfileTap() {
    context.push(AppRoutesName.editProfile);
  }

  void _onAboutUsTap() {
    context.push(
      AppRoutesName.webView,
      extra: const WebViewArgs(url: AppUrls.aboutUs, title: AppString.aboutUs),
    );
  }

  void _onTermsConditionsTap() {
    context.push(
      AppRoutesName.webView,
      extra: const WebViewArgs(
        url: AppUrls.termsAndConditions,
        title: AppString.termsAndConditionsRow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProfileViewModel, ProfileState>(
          buildWhen: (previous, current) =>
              previous.profileState != current.profileState,
          builder: (context, state) => _buildBody(context, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    final profileState = state.profileState;

    if (profileState.isLoading && profileState.data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (profileState.errorMessage.isNotEmpty && profileState.data == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(profileState.errorMessage, textAlign: TextAlign.center),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () =>
                  context.read<ProfileViewModel>().doEvent(ProfileRequested()),
              child: const Text(AppString.retry),
            ),
          ],
        ),
      );
    }

    final displayData = state.displayData;

    return RefreshIndicator(
      onRefresh: () =>
          context.read<ProfileViewModel>().doEvent(ProfileRequested()),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: displayData == null
                    ? const SizedBox.shrink()
                    : ProfileInfoSection(
                        data: displayData,
                        onEditTap: _onEditProfileTap,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ProfileOptionsSection(
                onNotificationsChanged: _onNotificationsChanged,
                onSavedAddressTap: _onSavedAddressTap,
                onLanguageTap: _onLanguageTap,
                onAboutUsTap: _onAboutUsTap,
                onTermsConditionsTap: _onTermsConditionsTap,
                onLogoutTap: _onLogoutTap,
                // My orders still has no destination in the app yet.
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
    );
  }
}

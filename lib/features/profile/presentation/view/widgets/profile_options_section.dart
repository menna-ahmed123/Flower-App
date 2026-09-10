import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_option_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The Profile screen's menu: navigation rows, the notification toggle and
/// the settings/logout group, laid out to match the Figma sectioning.
class ProfileOptionsSection extends StatelessWidget {
  const ProfileOptionsSection({
    super.key,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    this.onMyOrdersTap,
    this.onSavedAddressTap,
    this.onNotificationRowTap,
    this.onLanguageTap,
    this.onAboutUsTap,
    this.onTermsConditionsTap,
    required this.onLogoutTap,
  });

  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;

  final VoidCallback? onMyOrdersTap;
  final VoidCallback? onSavedAddressTap;
  final VoidCallback? onNotificationRowTap;
  final VoidCallback? onLanguageTap;
  final VoidCallback? onAboutUsTap;
  final VoidCallback? onTermsConditionsTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedLanguageLabel = context.locale.languageCode == 'ar'
        ? AppString.arabicLanguage
        : AppString.englishLanguage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileOptionRow(
          label: AppString.myOrders,
          icon: AppIcons.orders,
          onTap: onMyOrdersTap,
        ),
        ProfileOptionRow(
          label: AppString.savedAddresses,
          icon: AppIcons.location,
          onTap: onSavedAddressTap,
        ),
        _sectionDivider(colors),
        ProfileOptionRow(
          label: AppString.notification,
          leading: Switch(
            value: notificationsEnabled,
            activeColor: colors.white,
            activeTrackColor: colors.pink,
            onChanged: onNotificationsChanged,
          ),
          onTap: onNotificationRowTap,
        ),
        _sectionDivider(colors),
        ProfileOptionRow(
          label: AppString.language,
          icon: AppIcons.language,
          showChevron: false,
          trailing: Text(
            selectedLanguageLabel,
            style: TextStyle(color: colors.pink, fontSize: 11.sp),
          ),
          onTap: onLanguageTap,
        ),
        ProfileOptionRow(
          label: AppString.aboutUs,
          onTap: onAboutUsTap,
        ),
        ProfileOptionRow(
          label: AppString.termsAndConditionsRow,
          onTap: onTermsConditionsTap,
        ),
        _sectionDivider(colors),
        ProfileOptionRow(
          label: AppString.logout,
          icon: AppIcons.logout,
          showChevron: false,
          trailing: Icon(AppIcons.exit, size: 24.w, color: colors.black),
          onTap: onLogoutTap,
        ),
      ],
    );
  }

  Widget _sectionDivider(AppColors colors) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Divider(height: 1.h, color: colors.grey.shade600.withOpacity(0.3)),
    );
  }
}

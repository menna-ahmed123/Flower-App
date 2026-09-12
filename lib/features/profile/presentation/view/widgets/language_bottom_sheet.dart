import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Change Language" bottom sheet, reusing the app's existing
/// [EasyLocalization] locale plumbing already wired in `main.dart`.
class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  static const Locale arabicLocale = Locale('ar');
  static const Locale englishLocale = Locale('en');

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      builder: (_) => const LanguageBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDragHandle(context),
            SizedBox(height: 16.h),
            Text(
              AppString.changeLanguage,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.pink,
              ),
            ),
            SizedBox(height: 16.h),
            _buildLanguageOption(
              context,
              label: AppString.arabicLanguage,
              locale: arabicLocale,
            ),
            SizedBox(height: 12.h),
            _buildLanguageOption(
              context,
              label: AppString.englishLanguage,
              locale: englishLocale,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Center(
      child: Container(
        width: 80.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: context.colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String label,
    required Locale locale,
  }) {
    final colors = context.colors;
    final isSelected = context.locale.languageCode == locale.languageCode;

    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: () async {
        await context.setLocale(locale);
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withOpacity(0.1),
              blurRadius: 2.5.r,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: colors.black,
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? colors.pink : colors.grey.shade700,
              size: 24.w,
            ),
          ],
        ),
      ),
    );
  }
}

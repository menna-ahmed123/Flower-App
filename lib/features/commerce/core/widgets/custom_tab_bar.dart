import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final List<String> tabs;
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = selectedTab == tab;

          return GestureDetector(
            onTap: () => onTabSelected(tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colors.pink.withValues(alpha: 0.12)
                    : context.colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? context.colors.pink : Colors.transparent,
                  width: 1.2,
                ),
                boxShadow: [
                  if (!isSelected)
                    BoxShadow(
                      color: context.colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isSelected ? context.colors.pink : Colors.black87,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

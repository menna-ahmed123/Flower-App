import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/models/my_orders_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersTabs extends StatelessWidget {
  const OrdersTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final MyOrdersTab selectedTab;
  final ValueChanged<MyOrdersTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabItem(
            label: AppString.active,
            isSelected: selectedTab == MyOrdersTab.active,
            onTap: () => onTabSelected(MyOrdersTab.active),
          ),
        ),
        Expanded(
          child: _TabItem(
            label: AppString.completed,
            isSelected: selectedTab == MyOrdersTab.completed,
            onTap: () => onTabSelected(MyOrdersTab.completed),
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? context.colors.pink
                    : context.colors.grey.shade600,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2.h,
            color: isSelected ? context.colors.pink : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

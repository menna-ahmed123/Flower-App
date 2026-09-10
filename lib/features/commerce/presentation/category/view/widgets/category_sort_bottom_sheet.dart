import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/commerce/domain/entities/category_sort_by.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategorySortBottomSheet extends StatefulWidget {
  final CategorySortBy? initialSortBy;
  final ValueChanged<CategorySortBy> onApply;

  const CategorySortBottomSheet({
    super.key,
    this.initialSortBy,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    CategorySortBy? initialSortBy,
    required ValueChanged<CategorySortBy> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => CategorySortBottomSheet(
        initialSortBy: initialSortBy,
        onApply: onApply,
      ),
    );
  }

  @override
  State<CategorySortBottomSheet> createState() =>
      _CategorySortBottomSheetState();
}

class _CategorySortBottomSheetState extends State<CategorySortBottomSheet> {
  late CategorySortBy _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSortBy ?? CategorySortBy.lowestPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppString.sortBy,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.pink,
              ),
            ),
            SizedBox(height: 12.h),
            ...CategorySortBy.values.map(
              (sortType) => _buildSortOption(sortType),
            ),
            SizedBox(height: 16.h),
            AppButton(
              text: AppString.apply,
              onPressed: () {
                widget.onApply(_selectedSort);
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(CategorySortBy sortType) {
    final isSelected = _selectedSort == sortType;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSort = sortType;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: context.colors.grey.shade500,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? context.colors.pink
                : context.colors.grey.shade600.withOpacity(0.2),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sortType.title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: context.colors.black,
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? context.colors.pink
                  : context.colors.grey.shade700,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

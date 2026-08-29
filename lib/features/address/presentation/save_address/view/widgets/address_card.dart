import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.address,
    required this.onDelete,
    required this.onEdit,
    this.isDeleting = false,
  });

  final AddressEntity address;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = [
      address.address,
      address.area,
    ].where((value) => value != null && value.isNotEmpty).join(' - ');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.grey.shade600),
      ),
      child: Row(
        children: [
          Icon(AppIcons.locationFilled, color: colors.black, size: 24.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.city ?? '',
                  style: TextStyle(
                    color: colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colors.grey.shade800,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isDeleting)
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.error,
              ),
            )
          else
            IconButton(
              onPressed: onDelete,
              icon: Icon(AppIcons.trash, color: colors.error, size: 22.w),
            ),
          IconButton(
            onPressed: onEdit,
            icon: Icon(AppIcons.edit, color: colors.grey.shade800, size: 22.w),
          ),
        ],
      ),
    );
  }
}

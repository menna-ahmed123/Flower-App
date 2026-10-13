import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EstimatedArrivalSection extends StatelessWidget {
  const EstimatedArrivalSection({
    super.key,
    required this.estimatedArrivalDateTime,
  });

  /// null until the backend provides an ETA.
  final DateTime? estimatedArrivalDateTime;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final eta = estimatedArrivalDateTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppString.estimatedArrival, style: textTheme.bodyMedium),
              SizedBox(height: 8.h),
              Text(
                eta == null
                    ? '--'
                    : DateFormat('d MMMM yyyy, h:mm a').format(eta.toLocal()),
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Divider(color: context.colors.grey.shade700),
      ],
    );
  }
}

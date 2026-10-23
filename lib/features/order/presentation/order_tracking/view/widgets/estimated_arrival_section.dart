import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/extensions/tracking_date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EstimatedArrivalSection extends StatelessWidget {
  const EstimatedArrivalSection({
    super.key,
    this.estimatedArrivalDateTime,
  });

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
                eta == null ? AppString.noDataPlaceholder : eta.trackingEtaLabel,
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

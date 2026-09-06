
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/presentation/save_address/view/widgets/animation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressCard extends StatefulWidget {
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
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  void _delete() {
    if (_controller.isAnimating || widget.isDeleting) return;

    _controller.forward().then((_) {
      widget.onDelete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final subtitle = [
      widget.address.address,
      widget.address.area,
    ].where(
      (value) => value != null && value.isNotEmpty,
    ).join(' - ');

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Opacity(
              opacity: 1 - progress,
              child: Transform.scale(
                scale: 1 - (progress * 0.05),
                child: child,
              ),
            ),

            // الـ particles
            if (progress > 0)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: AnimationCard(
                      progress: progress,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10.r,
              spreadRadius: 1.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              AppIcons.locationFilled,
              color: colors.black,
              size: 24.w,
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.address.city ?? '',
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

            if (widget.isDeleting)
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
                onPressed: _delete,
                icon: Icon(
                  AppIcons.trash,
                  color: colors.error,
                  size: 22.w,
                ),
              ),

            IconButton(
              onPressed: widget.onEdit,
              icon: Icon(
                AppIcons.edit,
                color: colors.grey.shade800,
                size: 22.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
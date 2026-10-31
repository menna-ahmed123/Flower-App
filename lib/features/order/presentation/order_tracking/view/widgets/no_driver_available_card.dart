import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "No delivery driver yet" state. Takes the driver card's place while
/// `driver == null`; the pulse tells the user we're still looking.
class NoDriverAvailableCard extends StatefulWidget {
  const NoDriverAvailableCard({super.key});

  @override
  State<NoDriverAvailableCard> createState() => _NoDriverAvailableCardState();
}

class _NoDriverAvailableCardState extends State<NoDriverAvailableCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pink = context.colors.pink;
    return Row(
      children: [
        FadeTransition(
          opacity: Tween<double>(begin: 0.45, end: 1).animate(_pulse),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: pink.withValues(alpha: 0.15),
            child: Icon(Icons.delivery_dining, color: pink),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.noDriverAvailable,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                AppString.findingDriver,
                style: TextStyle(
                  color: context.colors.black.shade50,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_color.dart';
import 'custom_contract_card.dart';

class DeliveryInformationCard extends StatelessWidget {
  const DeliveryInformationCard({
    super.key,
    required this.deliveryName,
    required this.deliveryPhoneNumber,
  });

  final String deliveryName;
  final String deliveryPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: context.colors.pink,
          child: Icon(Icons.person, color: context.colors.white),
        ),
        SizedBox(width: 16.w),
        // Expanded pushes the call/WhatsApp icons to the right edge (Figma).
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deliveryName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                'Is your delivery hero for today',
                style: TextStyle(
                  color: context.colors.black.shade50,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        CustomContractCard(phoneNumber: deliveryPhoneNumber),
      ],
    );
  }
}
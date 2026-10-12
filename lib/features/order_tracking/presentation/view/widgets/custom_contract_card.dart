import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/image_path/images_path.dart';
import '../../../core/helper/phone_launcher.dart';
import '../../../core/helper/whatsapp_launcher.dart';

class CustomContractCard extends StatelessWidget {
  const CustomContractCard({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => phoneLauncher(phoneNumber, context),
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(ImagesPath.phone, width: 22, height: 22),
        ),

        IconButton(
          onPressed: () => whatsAppLauncher(phoneNumber, context),
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(ImagesPath.whatsapp, width: 22, height: 22),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/utils/image_path/images_path.dart';
import 'package:flower_app/features/order/core/helper/url_launcher_service.dart';
import 'package:flower_app/features/order/core/helper/url_launcher_service_impl.dart';

class CustomContactCard extends StatelessWidget {
  const CustomContactCard({
    super.key,
    required this.phoneNumber,
    this.launcher = const UrlLauncherServiceImpl(),
  });

  final String phoneNumber;

  /// Injectable so widget tests can fake the platform launch.
  final UrlLauncherService launcher;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _launch(context, launcher.launchPhone(phoneNumber)),
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(ImagesPath.phone, width: 22, height: 22),
        ),

        IconButton(
          onPressed: () =>
              _launch(context, launcher.launchWhatsApp(phoneNumber)),
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(ImagesPath.whatsapp, width: 22, height: 22),
        ),
      ],
    );
  }

  Future<void> _launch(BuildContext context, Future<bool> launched) async {
    if (await launched) return;
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(AppString.somethingWrong),
          backgroundColor: context.colors.error,
        ),
      );
  }
}

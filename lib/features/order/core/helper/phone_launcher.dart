import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> phoneLauncher(String phoneNumber, BuildContext context) async {
  final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
  if(await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    if(!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Some Thing Went Wrong'),
          backgroundColor: context.colors.error,
        ),
      );
  }
}

import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Placeholder destination for the Profile pen icon; the real Edit Profile
/// feature (form, validation, update API) is implemented separately.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppString.editProfile,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutesName.profile);
          }
        },
      ),
      body: const SafeArea(child: SizedBox.shrink()),
    );
  }
}

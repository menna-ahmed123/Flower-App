import 'package:flower_app/features/forget_password/presentation/pages/widgets/reset_password_body.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_string.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppString.password)),
      body: ResetPasswordBody(),
    );
  }
}

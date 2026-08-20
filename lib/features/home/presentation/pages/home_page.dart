import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.home)),
      body: const Center(child: Text(AppString.home)),
    );
  }
}

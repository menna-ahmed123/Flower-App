import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.categories)),
      body: const Center(child: Text(AppString.categories)),
    );
  }
}

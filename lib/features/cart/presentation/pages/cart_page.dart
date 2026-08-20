import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.cart)),
      body: const Center(child: Text(AppString.cart)),
    );
  }
}

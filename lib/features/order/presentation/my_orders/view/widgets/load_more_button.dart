import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';

class LoadMoreButton extends StatelessWidget {
  const LoadMoreButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: const Text(AppString.loadMore),
      ),
    );
  }
}

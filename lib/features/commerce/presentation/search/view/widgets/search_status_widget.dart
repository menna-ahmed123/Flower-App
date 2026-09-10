import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_color.dart';

class SearchStatusWidget extends StatelessWidget {
  const SearchStatusWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: context.colors.pink,
        ),
      ),
    );
  }
}

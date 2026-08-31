import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class DropDown<T> extends StatelessWidget {
  final String labelText;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;

  const DropDown({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,

      hint: Text(hintText, style: const TextStyle(color: Colors.grey)),

      decoration: InputDecoration(labelText: labelText),
      dropdownColor: context.colors.pink.shade100,
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }
}

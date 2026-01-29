import 'package:flutter/material.dart';
import '../textbox/v_textbox.dart';

class VSearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Object? prefixIcon;
  final Object? suffixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;

  const VSearchBox({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return VTextBox(
      controller: controller,
      label: label,
      hint: hint ?? 'Search',
      prefixIcon: prefixIcon ?? const Icon(Icons.search),
      suffixIcon: suffixIcon,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onEditingComplete: onSubmitted,
    );
  }
}

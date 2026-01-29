import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../textbox/v_textbox.dart';

class VMaskedTextBox extends StatelessWidget {
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;
  final String? label;
  final String? hint;
  final Object? prefixIcon;
  final Object? suffixIcon;
  final ValueChanged<String>? onChanged;

  const VMaskedTextBox({
    super.key,
    required this.controller,
    required this.inputFormatters,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return VTextBox(
      controller: controller,
      label: label,
      hint: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
    );
  }
}

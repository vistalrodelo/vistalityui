import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../textbox/v_textbox.dart';

class VNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Object? prefixIcon;
  final Object? suffixIcon;
  final bool allowDecimal;
  final ValueChanged<String>? onChanged;

  const VNumberInput({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.allowDecimal = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final pattern = allowDecimal ? r'[0-9.]' : r'[0-9]';
    return VTextBox(
      controller: controller,
      label: label,
      hint: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(pattern)),
      ],
      onChanged: onChanged,
    );
  }
}

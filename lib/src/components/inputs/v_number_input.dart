import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../textbox/v_textbox.dart';

/// Numeric input built on top of [VTextBox].
class VNumberInput extends StatelessWidget {
  /// Controller for the input value.
  final TextEditingController controller;

  /// Optional label text.
  final String? label;

  /// Optional hint text.
  final String? hint;

  /// Optional prefix icon.
  final Object? prefixIcon;

  /// Optional suffix icon.
  final Object? suffixIcon;

  /// Whether decimal values are allowed.
  final bool allowDecimal;

  /// Called when the value changes.
  final ValueChanged<String>? onChanged;

  /// Creates a [VNumberInput].
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

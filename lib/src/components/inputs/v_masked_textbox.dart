import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../textbox/v_textbox.dart';

/// Text input that applies input formatters.
class VMaskedTextBox extends StatelessWidget {
  /// Controller for the input value.
  final TextEditingController controller;

  /// Input formatters applied to the field.
  final List<TextInputFormatter> inputFormatters;

  /// Optional label text.
  final String? label;

  /// Optional hint text.
  final String? hint;

  /// Optional prefix icon.
  final Object? prefixIcon;

  /// Optional suffix icon.
  final Object? suffixIcon;

  /// Called when the value changes.
  final ValueChanged<String>? onChanged;

  /// Creates a [VMaskedTextBox].
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

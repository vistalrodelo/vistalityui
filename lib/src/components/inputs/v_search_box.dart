import 'package:flutter/material.dart';
import '../textbox/v_textbox.dart';

/// Search input built on top of [VTextBox].
class VSearchBox extends StatelessWidget {
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

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field.
  final VoidCallback? onSubmitted;

  /// Creates a [VSearchBox].
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

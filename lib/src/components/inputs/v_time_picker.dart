import 'package:flutter/material.dart';
import '../textbox/v_textbox.dart';

/// Read-only text field that opens a time picker.
class VTimePickerField extends StatelessWidget {
  /// Currently selected time.
  final TimeOfDay? value;

  /// Called when the time changes.
  final ValueChanged<TimeOfDay?>? onChanged;

  /// Controller for the input display.
  final TextEditingController controller;

  /// Optional label text.
  final String? label;

  /// Optional hint text.
  final String? hint;

  /// Optional prefix icon.
  final Object? prefixIcon;

  /// Optional suffix icon.
  final Object? suffixIcon;

  /// Creates a [VTimePickerField].
  const VTimePickerField({
    super.key,
    required this.controller,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (value != null) {
      controller.text = value!.format(context);
    }
    return VTextBox(
      controller: controller,
      label: label,
      hint: hint ?? 'Select time',
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      readOnly: true,
      onTap: () async {
        final now = TimeOfDay.now();
        final picked = await showTimePicker(
          context: context,
          initialTime: value ?? now,
        );
        if (picked != null) {
          if (!context.mounted) return;
          controller.text = picked.format(context);
        }
        onChanged?.call(picked);
      },
    );
  }
}

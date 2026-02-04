import 'package:flutter/material.dart';
import '../textbox/v_textbox.dart';

/// Read-only text field that opens a date picker.
class VDatePickerField extends StatelessWidget {
  /// Currently selected date.
  final DateTime? value;

  /// Called when the date changes.
  final ValueChanged<DateTime?>? onChanged;

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

  /// Earliest selectable date.
  final DateTime? firstDate;

  /// Latest selectable date.
  final DateTime? lastDate;

  /// Creates a [VDatePickerField].
  const VDatePickerField({
    super.key,
    required this.controller,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    if (value != null) {
      controller.text = _formatDate(value!);
    }
    return VTextBox(
      controller: controller,
      label: label,
      hint: hint ?? 'Select date',
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      readOnly: true,
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: firstDate ?? DateTime(now.year - 100),
          lastDate: lastDate ?? DateTime(now.year + 100),
        );
        if (picked != null) {
          controller.text = _formatDate(picked);
        }
        onChanged?.call(picked);
      },
    );
  }
}

String _formatDate(DateTime value) {
  final m = value.month.toString().padLeft(2, '0');
  final d = value.day.toString().padLeft(2, '0');
  return '${value.year}-$m-$d';
}

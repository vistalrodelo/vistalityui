import 'package:flutter/material.dart';
import '../textbox/v_textbox.dart';

/// Read-only text field that picks date and time.
class VDateTimePickerField extends StatelessWidget {
  /// Currently selected date time.
  final DateTime? value;

  /// Called when the value changes.
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

  /// Creates a [VDateTimePickerField].
  const VDateTimePickerField({
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
      controller.text = _formatDateTime(value!, context);
    }
    return VTextBox(
      controller: controller,
      label: label,
      hint: hint ?? 'Select date & time',
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      readOnly: true,
      onTap: () async {
        final now = DateTime.now();
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 100),
          lastDate: DateTime(now.year + 100),
        );
        if (pickedDate == null) {
          onChanged?.call(null);
          return;
        }
        if (!context.mounted) return;
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(value ?? now),
        );
        if (pickedTime == null) {
          onChanged?.call(null);
          return;
        }
        if (!context.mounted) return;
        final combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        controller.text = _formatDateTime(combined, context);
        onChanged?.call(combined);
      },
    );
  }
}

String _formatDateTime(DateTime value, BuildContext context) {
  final m = value.month.toString().padLeft(2, '0');
  final d = value.day.toString().padLeft(2, '0');
  final date = '${value.year}-$m-$d';
  final time = TimeOfDay.fromDateTime(value).format(context);
  return '$date $time';
}

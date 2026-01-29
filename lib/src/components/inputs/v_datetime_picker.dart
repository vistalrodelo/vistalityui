import 'package:flutter/material.dart';
import '../textbox/v_textbox.dart';

class VDateTimePickerField extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Object? prefixIcon;
  final Object? suffixIcon;

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
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(value ?? now),
        );
        if (pickedTime == null) {
          onChanged?.call(null);
          return;
        }
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

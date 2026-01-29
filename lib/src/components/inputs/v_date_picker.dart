import 'package:flutter/material.dart';
import '../textbox/v_textbox.dart';

class VDatePickerField extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Object? prefixIcon;
  final Object? suffixIcon;
  final DateTime? firstDate;
  final DateTime? lastDate;

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

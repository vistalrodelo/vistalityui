import 'package:flutter/material.dart';
import '../textbox/v_textbox.dart';

class VTimePickerField extends StatelessWidget {
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay?>? onChanged;
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Object? prefixIcon;
  final Object? suffixIcon;

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
          controller.text = picked.format(context);
        }
        onChanged?.call(picked);
      },
    );
  }
}

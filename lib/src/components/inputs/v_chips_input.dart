import 'package:flutter/material.dart';
import '../textbox/v_textbox.dart';
import 'v_chip.dart';

class VChipsInput extends StatelessWidget {
  final List<String> values;
  final ValueChanged<List<String>>? onChanged;
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Object? prefixIcon;
  final Object? suffixIcon;
  final bool enabled;

  const VChipsInput({
    super.key,
    required this.values,
    required this.onChanged,
    required this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VTextBox(
          controller: controller,
          label: label,
          hint: hint ?? 'Add a tag',
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabled: enabled,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _addTag(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values
              .map((v) => VChip(
                    label: v,
                    onDeleted: enabled ? () => _removeTag(v) : null,
                  ))
              .toList(),
        ),
      ],
    );
  }

  void _addTag() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    final next = List<String>.from(values);
    if (!next.contains(text)) next.add(text);
    controller.clear();
    onChanged?.call(next);
  }

  void _removeTag(String value) {
    final next = List<String>.from(values);
    next.remove(value);
    onChanged?.call(next);
  }
}

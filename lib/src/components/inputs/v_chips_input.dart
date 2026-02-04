import 'package:flutter/material.dart';
import '../textbox/v_textbox.dart';
import 'v_chip.dart';

/// Input that collects multiple string values as chips.
class VChipsInput extends StatelessWidget {
  /// Current chip values.
  final List<String> values;

  /// Called when the values change.
  final ValueChanged<List<String>>? onChanged;

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

  /// Whether the input is enabled.
  final bool enabled;

  /// Creates a [VChipsInput].
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

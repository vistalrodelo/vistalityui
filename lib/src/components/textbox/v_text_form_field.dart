import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'v_textbox.dart';

/// [VTextBox] that participates in a [Form].
class VTextFormField extends StatefulWidget {
  /// Optional controller. One is created when omitted.
  final TextEditingController? controller;

  /// Initial text used when [controller] is null.
  final String? initialValue;

  /// Label displayed above the input.
  final String? label;

  /// Hint text displayed when empty.
  final String? hint;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether to obscure the text.
  final bool obscureText;

  /// Optional prefix icon.
  final Object? prefixIcon;

  /// Keyboard type for the field.
  final TextInputType? keyboardType;

  /// Action button for the keyboard.
  final TextInputAction? textInputAction;

  /// Maximum character length.
  final int? maxLength;

  /// Input formatters applied to the text.
  final List<TextInputFormatter>? inputFormatters;

  /// Validates the current value. Return an error string or null.
  final FormFieldValidator<String>? validator;

  /// Called when the form saves this field.
  final FormFieldSetter<String>? onSaved;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// When the field validates itself.
  final AutovalidateMode autovalidateMode;

  /// Creates a [VTextFormField].
  const VTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.enabled = true,
    this.obscureText = false,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
  }) : assert(
         controller == null || initialValue == null,
         'controller and initialValue cannot both be set',
       );

  @override
  State<VTextFormField> createState() => _VTextFormFieldState();
}

class _VTextFormFieldState extends State<VTextFormField> {
  TextEditingController? _owned;

  TextEditingController get _controller => widget.controller ?? _owned!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _owned = TextEditingController(text: widget.initialValue ?? '');
    }
  }

  @override
  void didUpdateWidget(VTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && _owned == null) {
      _owned = TextEditingController(text: widget.initialValue ?? '');
    } else if (widget.controller != null && _owned != null) {
      _owned!.dispose();
      _owned = null;
    }
  }

  @override
  void dispose() {
    _owned?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _controller.text,
      validator: widget.validator,
      onSaved: widget.onSaved,
      autovalidateMode: widget.autovalidateMode,
      builder: (field) {
        return VTextBox(
          controller: _controller,
          label: widget.label,
          hint: widget.hint,
          enabled: widget.enabled,
          obscureText: widget.obscureText,
          prefixIcon: widget.prefixIcon,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          errorText: field.errorText,
          onChanged: (value) {
            field.didChange(value);
            widget.onChanged?.call(value);
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

class VTextBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  final String? label;
  final String? hint;
  final String? errorText;

  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool filled;
  final bool multiline;
  final bool allowNewLineButton;
  final bool allowClearButton;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? Function(String value)? validator;
  final List<TextInputFormatter>? inputFormatters;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  final Object? prefixIcon;
  final Object? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final Object? radius;
  final double? radiusValue;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;

  const VTextBox({
    super.key,
    required this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.filled = true,
    this.multiline = false,
    this.allowNewLineButton = false,
    this.allowClearButton = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.radius,
    this.radiusValue,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (validator != null && errorText == null) {
      return ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, _, __) {
          final validationError = validator!(controller.text);
          return _buildTextField(context, validationError);
        },
      );
    }
    return _buildTextField(context, errorText);
  }

  Widget _buildTextField(BuildContext context, String? resolvedErrorText) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);
    final borderRadius = context.vRadius.resolveBorderRadius(
      radius: radius,
      radiusValue: radiusValue,
    );

    final border = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: vc.outline),
    );

    final resolvedMinLines = multiline ? (minLines ?? 2) : minLines;
    final resolvedMaxLines =
        multiline ? (maxLines == 1 ? null : maxLines) : maxLines;
    final resolvedKeyboardType =
        keyboardType ?? (multiline ? TextInputType.multiline : null);
    final resolvedTextInputAction =
        textInputAction ?? (multiline ? TextInputAction.newline : null);

    final hasOverlayActions = allowNewLineButton || allowClearButton;
    final basePadding =
        (contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 12))
            .resolve(Directionality.of(context));
    final resolvedPadding = hasOverlayActions
        ? EdgeInsets.fromLTRB(
            basePadding.left,
            basePadding.top,
            basePadding.right + 36,
            basePadding.bottom,
          )
        : basePadding;

    final textField = TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      maxLines: resolvedMaxLines,
      minLines: resolvedMinLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      keyboardType: resolvedKeyboardType,
      textInputAction: resolvedTextInputAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: resolvedErrorText,
        prefixIcon: _resolveIcon(prefixIcon),
        suffixIcon: _resolveIcon(suffixIcon),
        isDense: true,
        filled: filled,
        fillColor: enabled ? cs.surface : cs.surface.withOpacity(0.4),
        contentPadding: resolvedPadding,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: vc.primary, width: 2),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: vc.error),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: vc.error, width: 2),
        ),
      ),
    );

    if (!hasOverlayActions) return textField;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        textField,
        if (allowClearButton)
          Positioned(
            top: 6,
            right: 6,
            child: _buildClearIcon(),
          ),
        if (allowNewLineButton)
          Positioned(
            bottom: 6,
            right: 6,
            child: _buildNewLineIcon(),
          ),
      ],
    );
  }

  Widget _buildNewLineIcon() {
    return IconButton(
      icon: const Icon(Icons.keyboard_return, size: 18),
      tooltip: 'New line',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 28, height: 28),
      onPressed: enabled && !readOnly ? _insertNewLine : null,
    );
  }

  Widget? _resolveIcon(Object? icon) {
    if (icon == null) return null;
    if (icon is Widget) return icon;
    if (icon is IconData) return Icon(icon);
    return null;
  }

  Widget _buildClearIcon() {
    return IconButton(
      icon: const Icon(Icons.clear, size: 18),
      tooltip: 'Clear',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 28, height: 28),
      onPressed: enabled && !readOnly ? _clearText : null,
    );
  }

  void _insertNewLine() {
    final text = controller.text;
    final selection = controller.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final newText = text.replaceRange(start, end, '\n');

    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: start + 1),
      composing: TextRange.empty,
    );
  }

  void _clearText() {
    controller.clear();
    onChanged?.call('');
  }

  String? validate() {
    if (validator == null) return null;
    return validator!(controller.text);
  }
}

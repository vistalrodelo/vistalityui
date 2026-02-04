import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../foundation/v_control_sizes.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

/// A styled text input with optional validation and overlays.
class VTextBox extends StatelessWidget {
  /// Controller that holds the current text value.
  final TextEditingController controller;

  /// Optional focus node for external focus control.
  final FocusNode? focusNode;

  /// Label displayed above the input.
  final String? label;

  /// Hint text displayed when empty.
  final String? hint;

  /// Error text shown below the input.
  final String? errorText;

  /// Whether the input is enabled.
  final bool enabled;

  /// Whether the input is read-only.
  final bool readOnly;

  /// Whether to obscure the text (password fields).
  final bool obscureText;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether to enable suggestions.
  final bool enableSuggestions;

  /// Whether the input has a filled background.
  final bool filled;

  /// Whether the input supports multiple lines.
  final bool multiline;

  /// Whether to show a "new line" overlay button.
  final bool allowNewLineButton;

  /// Whether to show a clear overlay button.
  final bool allowClearButton;

  /// Maximum number of lines to display.
  final int? maxLines;

  /// Minimum number of lines to display.
  final int? minLines;

  /// Maximum character length.
  final int? maxLength;

  /// Validation callback for the current value.
  final String? Function(String value)? validator;

  /// Input formatters applied to the text field.
  final List<TextInputFormatter>? inputFormatters;

  /// Keyboard type to use for the field.
  final TextInputType? keyboardType;

  /// Action button for the keyboard.
  final TextInputAction? textInputAction;

  /// Text capitalization behavior.
  final TextCapitalization textCapitalization;

  /// Optional prefix icon (widget or IconData).
  final Object? prefixIcon;

  /// Optional suffix icon (widget or IconData).
  final Object? suffixIcon;

  /// Padding inside the input field.
  final EdgeInsetsGeometry? contentPadding;

  /// Optional height override for single-line fields.
  final double? controlHeight;

  /// Whether to show error text below the field.
  final bool showErrorText;

  /// Radius token or identifier resolved by [VRadius].
  final Object? radius;

  /// Explicit radius override when not using a token.
  final double? radiusValue;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field.
  final ValueChanged<String>? onSubmitted;

  /// Called when editing completes.
  final VoidCallback? onEditingComplete;

  /// Called when the field is tapped.
  final VoidCallback? onTap;

  /// Creates a [VTextBox] with styling and validation options.
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
    this.controlHeight,
    this.showErrorText = true,
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
        builder: (context, _, _) {
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

    final resolvedHeight =
        multiline ? null : (controlHeight ?? VControlSizes.fieldHeight);
    final iconConstraints = resolvedHeight == null
        ? null
        : BoxConstraints(
            minHeight: resolvedHeight,
            minWidth: resolvedHeight,
          );
    final hasError = resolvedErrorText != null && resolvedErrorText.isNotEmpty;
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
      textAlignVertical:
          resolvedHeight == null ? null : TextAlignVertical.center,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: hasError ? '' : null,
        errorStyle: hasError
            ? const TextStyle(fontSize: 0, height: 0)
            : null,
        prefixIcon: _resolveIcon(prefixIcon),
        suffixIcon: _resolveIcon(suffixIcon),
        prefixIconConstraints: iconConstraints,
        suffixIconConstraints: iconConstraints,
        isDense: true,
        filled: filled,
        fillColor: enabled ? cs.surface : cs.surface.withValues(alpha: 0.4),
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

    Widget fieldContent = textField;
    if (hasOverlayActions) {
      fieldContent = Stack(
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

    if (resolvedHeight != null) {
      fieldContent = SizedBox(
        height: resolvedHeight,
        child: SizedBox.expand(child: fieldContent),
      );
    }

    if (!hasError || !showErrorText) return fieldContent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldContent,
        const SizedBox(height: 2),
        Text(
          resolvedErrorText!,
          style: TextStyle(
            color: vc.error,
            fontSize: 12,
          ),
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

  /// Runs the validator against the current value.
  String? validate() {
    if (validator == null) return null;
    return validator!(controller.text);
  }
}

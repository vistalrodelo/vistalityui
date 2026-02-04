import 'package:flutter/material.dart';
import '../../foundation/v_breakpoints.dart';
import '../../foundation/v_control_sizes.dart';
import '../../foundation/v_intent.dart';
import '../button/v_button.dart';
import '../checkbox/v_checkbox.dart';
import '../dropdown/v_dropdown.dart';
import '../dropdown/v_multi_select_dropdown.dart';
import '../radio/v_radio.dart';
import '../textbox/v_textbox.dart';

/// Supported form field types for [VFormFieldConfig].
enum VFormFieldType {
  /// Single-line text input.
  text,

  /// Multiline text input.
  multiline,

  /// Password input.
  password,

  /// Single-select dropdown.
  dropdown,

  /// Multi-select dropdown.
  multiselect,

  /// Checkbox input.
  checkbox,

  /// Radio group input.
  radio,
}

/// Radio option definition for [VForm].
class VRadioOption<T> {
  /// Underlying value for the option.
  final T value;

  /// Label text shown when [child] is not provided.
  final String label;

  /// Optional custom widget for the option.
  final Widget? child;

  /// Creates a [VRadioOption].
  const VRadioOption({
    required this.value,
    required this.label,
    this.child,
  });
}

/// Configuration model for a field rendered by [VForm].
class VFormFieldConfig<T> {
  /// Unique identifier for the field.
  final String id;

  /// Field type that controls rendering.
  final VFormFieldType type;

  /// Label shown for the field.
  final String label;

  /// Optional hint text.
  final String? hint;

  /// Whether the field is required.
  final bool required;

  /// Whether the field is enabled.
  final bool enabled;

  /// Optional controller for text-based fields.
  final TextEditingController? controller;

  /// Initial text for text-based fields.
  final String? initialText;

  /// Whether a clear button is shown for text fields.
  final bool allowClearButton;

  /// Whether a new line button is shown for multiline fields.
  final bool allowNewLineButton;

  /// Maximum character length for text fields.
  final int? maxLength;

  /// Keyboard type for text fields.
  final TextInputType? keyboardType;

  /// Keyboard action for text fields.
  final TextInputAction? textInputAction;

  /// Optional prefix icon.
  final Object? prefixIcon;

  /// Optional suffix icon.
  final Object? suffixIcon;

  /// Items for dropdown fields.
  final List<VDropdownItem<T>>? items;

  /// Items for multi-select fields.
  final List<VMultiSelectItem<T>>? multiItems;

  /// Options for radio fields.
  final List<VRadioOption<T>>? radioOptions;

  /// Initial value for single-choice fields.
  final T? initialValue;

  /// Initial values for multi-select fields.
  final List<T>? initialValues;

  /// Validation for text fields.
  final String? Function(String value)? validator;

  /// Validation for non-text fields.
  final String? Function(Object? value)? validatorAny;

  /// Initial value for checkbox fields.
  final bool? checkboxInitialValue;

  /// Internal constructor for shared field settings.
  VFormFieldConfig._({
    required this.id,
    required this.type,
    required this.label,
    this.hint,
    this.required = false,
    this.enabled = true,
    this.controller,
    this.initialText,
    this.allowClearButton = false,
    this.allowNewLineButton = false,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.items,
    this.multiItems,
    this.radioOptions,
    this.initialValue,
    this.initialValues,
    this.validator,
    this.validatorAny,
    this.checkboxInitialValue,
  });

  /// Creates a text field configuration.
  VFormFieldConfig.text({
    required String id,
    required String label,
    String? hint,
    bool required = false,
    bool enabled = true,
    TextEditingController? controller,
    String? initialText,
    bool allowClearButton = false,
    int? maxLength,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    Object? prefixIcon,
    Object? suffixIcon,
    String? Function(String value)? validator,
  }) : this._(
          id: id,
          type: VFormFieldType.text,
          label: label,
          hint: hint,
          required: required,
          enabled: enabled,
          controller: controller,
          initialText: initialText,
          allowClearButton: allowClearButton,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          validator: validator,
        );

  /// Creates a multiline text field configuration.
  VFormFieldConfig.multiline({
    required String id,
    required String label,
    String? hint,
    bool required = false,
    bool enabled = true,
    TextEditingController? controller,
    String? initialText,
    bool allowClearButton = false,
    bool allowNewLineButton = true,
    int? maxLength,
    Object? prefixIcon,
    Object? suffixIcon,
    String? Function(String value)? validator,
  }) : this._(
          id: id,
          type: VFormFieldType.multiline,
          label: label,
          hint: hint,
          required: required,
          enabled: enabled,
          controller: controller,
          initialText: initialText,
          allowClearButton: allowClearButton,
          allowNewLineButton: allowNewLineButton,
          maxLength: maxLength,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          validator: validator,
        );

  /// Creates a password field configuration.
  VFormFieldConfig.password({
    required String id,
    required String label,
    String? hint,
    bool required = false,
    bool enabled = true,
    TextEditingController? controller,
    String? initialText,
    bool allowClearButton = false,
    Object? prefixIcon,
    Object? suffixIcon,
    String? Function(String value)? validator,
  }) : this._(
          id: id,
          type: VFormFieldType.password,
          label: label,
          hint: hint,
          required: required,
          enabled: enabled,
          controller: controller,
          initialText: initialText,
          allowClearButton: allowClearButton,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          validator: validator,
        );

  /// Creates a dropdown field configuration.
  VFormFieldConfig.dropdown({
    required String id,
    required String label,
    String? hint,
    bool required = false,
    bool enabled = true,
    required List<VDropdownItem<T>> items,
    T? initialValue,
    String? Function(T? value)? validator,
  }) : this._(
          id: id,
          type: VFormFieldType.dropdown,
          label: label,
          hint: hint,
          required: required,
          enabled: enabled,
          items: items,
          initialValue: initialValue,
          validatorAny: validator == null ? null : (v) => validator(v is T ? v : null),
        );

  /// Creates a multi-select field configuration.
  VFormFieldConfig.multiselect({
    required String id,
    required String label,
    String? hint,
    bool required = false,
    bool enabled = true,
    required List<VMultiSelectItem<T>> items,
    List<T>? initialValues,
    String? Function(List<T> values)? validator,
  }) : this._(
          id: id,
          type: VFormFieldType.multiselect,
          label: label,
          hint: hint,
          required: required,
          enabled: enabled,
          multiItems: items,
          initialValues: initialValues,
          validatorAny: validator == null
              ? null
              : (v) => validator(v is List<T> ? v : List<T>.from(v as List)),
        );

  /// Creates a checkbox field configuration.
  VFormFieldConfig.checkbox({
    required String id,
    required String label,
    bool required = false,
    bool enabled = true,
    bool initialValue = false,
    String? Function(bool value)? validator,
  }) : this._(
          id: id,
          type: VFormFieldType.checkbox,
          label: label,
          required: required,
          enabled: enabled,
          checkboxInitialValue: initialValue,
          validatorAny: validator == null ? null : (v) => validator(v is bool ? v : false),
        );

  /// Creates a radio field configuration.
  VFormFieldConfig.radio({
    required String id,
    required String label,
    bool required = false,
    bool enabled = true,
    required List<VRadioOption<T>> options,
    T? initialValue,
    String? Function(T? value)? validator,
  }) : this._(
          id: id,
          type: VFormFieldType.radio,
          label: label,
          required: required,
          enabled: enabled,
          radioOptions: options,
          initialValue: initialValue,
          validatorAny: validator == null ? null : (v) => validator(v is T ? v : null),
        );
}

/// Signature for form submission callbacks.
typedef VFormSubmit = void Function(Map<String, dynamic> values);

/// Responsive form builder based on a list of field configs.
class VForm extends StatefulWidget {
  /// Field configurations to render.
  final List<VFormFieldConfig> fields;

  /// Number of columns to use for layout.
  final int columns;

  /// Spacing between fields.
  final double spacing;

  /// Label for the submit button.
  final String submitLabel;

  /// Label for the cancel button.
  final String cancelLabel;

  /// Optional cancel callback.
  final VoidCallback? onCancel;

  /// Optional submit callback with collected values.
  final VFormSubmit? onSubmit;

  /// Creates a [VForm].
  const VForm({
    super.key,
    required this.fields,
    this.columns = 1,
    this.spacing = 12,
    this.submitLabel = 'Submit',
    this.cancelLabel = 'Cancel',
    this.onCancel,
    this.onSubmit,
  }) : assert(columns >= 1 && columns <= 4);

  @override
  State<VForm> createState() => _VFormState();
}

class _VFormState extends State<VForm> {
  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (final field in widget.fields) {
      switch (field.type) {
        case VFormFieldType.text:
        case VFormFieldType.multiline:
        case VFormFieldType.password:
          final controller = field.controller ??
              TextEditingController(text: field.initialText ?? '');
          if (field.controller == null) {
            _controllers[field.id] = controller;
          }
          _values[field.id] = controller.text;
          break;
        case VFormFieldType.dropdown:
        case VFormFieldType.radio:
          _values[field.id] = field.initialValue;
          break;
        case VFormFieldType.multiselect:
          _values[field.id] = List.from(field.initialValues ?? const []);
          break;
        case VFormFieldType.checkbox:
          _values[field.id] = field.checkboxInitialValue ?? false;
          break;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxColumns = widget.columns.clamp(1, 4);
        final width = constraints.maxWidth;
        final columns = _resolveColumns(width, maxColumns);
        final spacing = widget.spacing;
        final itemWidth = (width - spacing * (columns - 1)) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: widget.fields
                  .map((field) => SizedBox(
                        width: itemWidth,
                        child: _buildField(field),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                VButton(
                  label: widget.cancelLabel,
                  intent: VIntent.secondary,
                  size: VButtonSize.sm,
                  onPressed: widget.onCancel ?? () {},
                ),
                const SizedBox(width: 12),
                VButton(
                  label: widget.submitLabel,
                  size: VButtonSize.sm,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  int _resolveColumns(double width, int maxColumns) {
    if (width < VBreakpoints.md) {
      return 1;
    }
    if (width < VBreakpoints.lg) {
      return maxColumns.clamp(1, 2);
    }
    return maxColumns;
  }

  Widget _buildField(VFormFieldConfig field) {
    final error = _errors[field.id];
    final fieldWidget = () {
      switch (field.type) {
      case VFormFieldType.text:
      case VFormFieldType.multiline:
      case VFormFieldType.password:
        final controller = field.controller ?? _controllers[field.id]!;
        return VTextBox(
          controller: controller,
          label: _label(field),
          hint: field.hint,
          errorText: error,
          showErrorText: false,
          enabled: field.enabled,
          multiline: field.type == VFormFieldType.multiline,
          obscureText: field.type == VFormFieldType.password,
          allowClearButton: field.allowClearButton,
          allowNewLineButton: field.allowNewLineButton,
          maxLength: field.maxLength,
          keyboardType: field.keyboardType,
          textInputAction: field.textInputAction,
          prefixIcon: field.prefixIcon,
          suffixIcon: field.suffixIcon,
          controlHeight: field.type == VFormFieldType.multiline
              ? null
              : VControlSizes.fieldHeight,
          onChanged: (value) {
            _values[field.id] = value;
            _clearError(field.id);
          },
        );
      case VFormFieldType.dropdown:
        return VDropdown(
          label: _label(field),
          hint: field.hint,
          value: _values[field.id],
          items: field.items ?? const [],
          enabled: field.enabled,
          errorText: error,
          showErrorText: false,
          controlHeight: VControlSizes.fieldHeight,
          onChanged: (value) {
            setState(() {
              _values[field.id] = value;
              _errors.remove(field.id);
            });
          },
        );
      case VFormFieldType.multiselect:
        return VMultiSelectDropdown(
          label: _label(field),
          hint: field.hint,
          values: List.from(_values[field.id] ?? const []),
          items: field.multiItems ?? const [],
          enabled: field.enabled,
          errorText: error,
          showErrorText: false,
          controlHeight: VControlSizes.fieldHeight,
          onChanged: (values) {
            setState(() {
              _values[field.id] = values;
              _errors.remove(field.id);
            });
          },
        );
      case VFormFieldType.checkbox:
        final checked = (_values[field.id] ?? false) as bool;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                VCheckbox(
                  value: checked,
                  onChanged: field.enabled
                      ? (v) {
                          setState(() {
                            _values[field.id] = v;
                            _errors.remove(field.id);
                          });
                        }
                      : null,
                ),
                const SizedBox(width: 10),
                Text(_label(field)),
              ],
            ),
          ],
        );
      case VFormFieldType.radio:
        final options = field.radioOptions ?? const [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_label(field)),
            const SizedBox(height: 6),
            ...options.map(
              (opt) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: VRadio(
                  value: opt.value,
                  groupValue: _values[field.id],
                  onChanged: field.enabled
                      ? (v) {
                          setState(() {
                            _values[field.id] = v;
                            _errors.remove(field.id);
                          });
                        }
                      : null,
                  child: opt.child ?? Text(opt.label),
                ),
              ),
            ),
          ],
        );
    }
    }();

    final fieldHeight = switch (field.type) {
      VFormFieldType.text => VControlSizes.fieldHeight,
      VFormFieldType.password => VControlSizes.fieldHeight,
      VFormFieldType.dropdown => VControlSizes.fieldHeight,
      VFormFieldType.multiselect => null,
      _ => null,
    };

    return _wrapWithErrorSlot(fieldWidget, error, fieldHeight: fieldHeight);
  }

  Widget _wrapWithErrorSlot(
    Widget field,
    String? error, {
    double? fieldHeight,
  }) {
    final sizedField = fieldHeight == null
        ? field
        : SizedBox(height: fieldHeight, child: field);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedField,
        const SizedBox(height: 2),
        SizedBox(
          height: 16,
          child: error == null
              ? null
              : Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    final errors = <String, String?>{};
    for (final field in widget.fields) {
      errors[field.id] = _validateField(field);
    }

    final hasErrors = errors.values.any((e) => e != null);
    setState(() => _errors
      ..clear()
      ..addAll(errors));

    if (hasErrors) return;
    widget.onSubmit?.call(Map<String, dynamic>.from(_values));
  }

  String? _validateField(VFormFieldConfig field) {
    final value = _values[field.id];

    switch (field.type) {
      case VFormFieldType.text:
      case VFormFieldType.multiline:
      case VFormFieldType.password:
        final text = (value as String?) ?? '';
        if (text.trim().isEmpty) {
          return field.required ? 'Required' : null;
        }
        return field.validator?.call(text);
      case VFormFieldType.dropdown:
      case VFormFieldType.radio:
        if (value == null) return field.required ? 'Required' : null;
        return field.validatorAny?.call(value);
      case VFormFieldType.multiselect:
        final list = (value as List?) ?? const [];
        if (list.isEmpty) {
          return field.required ? 'Select at least one' : null;
        }
        return field.validatorAny?.call(list);
      case VFormFieldType.checkbox:
        if (value == true) return null;
        final requiredError = field.required ? 'Required' : null;
        return field.validatorAny?.call(value) ?? requiredError;
    }
  }

  void _clearError(String id) {
    if (_errors[id] == null) return;
    setState(() => _errors.remove(id));
  }

  String _label(VFormFieldConfig field) {
    return field.required ? '${field.label} *' : field.label;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

/// Modern text field with consistent styling
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final bool readOnly;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool filled;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.onChanged,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.contentPadding,
    this.fillColor,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseDecoration = theme.inputDecorationTheme;

    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      readOnly: readOnly,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onTap: onTap,
      validator: validator,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      autovalidateMode: autovalidateMode,
      style: baseDecoration.labelStyle?.copyWith(
        color: enabled ? AppColors.textPrimary : AppColors.textDisabled,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: filled,
        fillColor: fillColor ?? baseDecoration.fillColor,
        contentPadding: contentPadding ?? baseDecoration.contentPadding,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20, color: AppColors.textTertiary)
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, size: 20, color: AppColors.textTertiary),
                onPressed: onSuffixPressed,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              )
            : null,
        counterText: maxLength != null ? '' : null,
        border: baseDecoration.border,
        enabledBorder: baseDecoration.enabledBorder,
        focusedBorder: baseDecoration.focusedBorder,
        errorBorder: baseDecoration.errorBorder,
        focusedErrorBorder: baseDecoration.focusedErrorBorder,
        disabledBorder: baseDecoration.disabledBorder,
        hintStyle: baseDecoration.hintStyle,
        labelStyle: baseDecoration.labelStyle,
        floatingLabelStyle: baseDecoration.floatingLabelStyle,
        errorStyle: baseDecoration.errorStyle,
        helperStyle: baseDecoration.helperStyle,
        counterStyle: baseDecoration.counterStyle,
        prefixIconColor: baseDecoration.prefixIconColor,
        suffixIconColor: baseDecoration.suffixIconColor,
      ),
    );
  }
}

/// Search field with filter and location buttons
class AppSearchField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onLocationPressed;
  final VoidCallback? onSearchPressed;
  final bool readOnly;

  const AppSearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onFilterPressed,
    this.onLocationPressed,
    this.onSearchPressed,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.input),
        boxShadow: AppShadows.searchBar,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onSearchPressed,
        readOnly: readOnly || onSearchPressed != null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
          prefixIcon: Icon(AppIcons.search, size: 20, color: AppColors.textTertiary),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onLocationPressed != null)
                IconButton(
                  icon: Icon(AppIcons.myLocation, size: 20, color: AppColors.textSecondary),
                  onPressed: onLocationPressed,
                  tooltip: 'Current Location',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              if (onFilterPressed != null)
                IconButton(
                  icon: Icon(AppIcons.filter, size: 20, color: AppColors.textSecondary),
                  onPressed: onFilterPressed,
                  tooltip: 'Filter',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
            ],
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: AppBorders.inputFocus,
          ),
        ),
        style: AppTypography.bodyMedium,
      ),
    );
  }
}

/// Text area for multi-line input
class AppTextArea extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final FocusNode? focusNode;

  const AppTextArea({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.maxLines = 4,
    this.minLines = 3,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: hint,
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      focusNode: focusNode,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
    );
  }
}

/// Dropdown/select field
class AppDropdownField<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T?>? validator;
  final bool enabled;
  final IconData? prefixIcon;
  final String Function(T?)? getLabel;

  const AppDropdownField({
    super.key,
    this.label,
    this.hint,
    required this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.getLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseDecoration = theme.inputDecorationTheme;

    return DropdownButtonFormField<T>(
      value: value,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20, color: AppColors.textTertiary)
            : null,
        filled: baseDecoration.filled,
        fillColor: baseDecoration.fillColor,
        contentPadding: baseDecoration.contentPadding,
        border: baseDecoration.border,
        enabledBorder: baseDecoration.enabledBorder,
        focusedBorder: baseDecoration.focusedBorder,
        errorBorder: baseDecoration.errorBorder,
        focusedErrorBorder: baseDecoration.focusedErrorBorder,
        disabledBorder: baseDecoration.disabledBorder,
        hintStyle: baseDecoration.hintStyle,
        labelStyle: baseDecoration.labelStyle,
        floatingLabelStyle: baseDecoration.floatingLabelStyle,
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item.value,
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(item.icon, size: 20, color: item.iconColor ?? AppColors.textSecondary),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(getLabel?.call(item.value) ?? item.label, style: AppTypography.bodyMedium),
            ],
          ),
        );
      }).toList(),
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      dropdownColor: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.input),
      icon: Icon(AppIcons.caretDown, size: 20, color: AppColors.textTertiary),
      isExpanded: true,
    );
  }
}

class AppDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;
  final Color? iconColor;

  const AppDropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
  });
}

/// Chip input for tags/multiple values
class AppChipInput extends StatelessWidget {
  final List<String> chips;
  final ValueChanged<List<String>> onChanged;
  final String hint;
  final int maxChips;
  final bool enabled;

  const AppChipInput({
    super.key,
    required this.chips,
    required this.onChanged,
    this.hint = 'Add a tag...',
    this.maxChips = 10,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ...chips.map((chip) => _buildChip(chip)),
            if (chips.length < maxChips && enabled)
              _buildAddChipField(),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String chip) {
    return InputChip(
      label: Text(chip, style: AppTypography.labelMedium),
      onDeleted: enabled ? () => onChanged(chips.where((c) => c != chip).toList()) : null,
      deleteIcon: Icon(AppIcons.close, size: 16, color: AppColors.textSecondary),
      backgroundColor: AppColors.primaryContainer,
      labelStyle: AppTypography.labelMedium.copyWith(color: AppColors.primary),
      deleteIconColor: AppColors.primary,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.chip)),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
    );
  }

  Widget _buildAddChipField() {
    final controller = TextEditingController();

    return SizedBox(
      width: 120,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.chip),
            borderSide: AppBorders.input,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.chip),
            borderSide: AppBorders.input,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.chip),
            borderSide: AppBorders.inputFocus,
          ),
        ),
        style: AppTypography.bodySmall,
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            onChanged([...chips, value.trim()]);
            controller.clear();
          }
        },
      ),
    );
  }
}

/// Number input with increment/decrement buttons
class AppNumberInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final num value;
  final num min;
  final num max;
  final num step;
  final ValueChanged<num> onChanged;
  final String? unit;
  final bool enabled;
  final FormFieldValidator<num>? validator;

  const AppNumberInput({
    super.key,
    this.label,
    this.hint,
    required this.value,
    required this.min,
    required this.max,
    this.step = 1,
    required this.onChanged,
    this.unit,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            label: label,
            hint: hint,
            initialValue: value.toString(),
            keyboardType: TextInputType.number,
            enabled: enabled,
            validator: validator != null ? (v) => validator!(num.tryParse(v ?? '')) : null,
            onChanged: (v) {
              final parsed = num.tryParse(v);
              if (parsed != null) onChanged(parsed);
            },
            suffixIcon: unit != null ? null : AppIcons.edit,
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          ),
        ),
        if (unit != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(unit!, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ],
      ],
    );
  }
}

/// OTP/PIN input field
class AppOtpInput extends StatelessWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;
  final bool enabled;

  const AppOtpInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
    this.autoFocus = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final controllers = List.generate(length, (_) => TextEditingController());
    final focusNodes = List.generate(length, (_) => FocusNode());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Container(
          width: 48,
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            enabled: enabled,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: AppTypography.headlineSmall,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: AppBorders.input,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: AppBorders.input,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: AppBorders.inputFocus,
              ),
            ),
            onChanged: (value) {
              onChanged?.call(_getCode(controllers));
              if (value.isNotEmpty && index < length - 1) {
                focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                focusNodes[index - 1].requestFocus();
              }
              if (_getCode(controllers).length == length) {
                onCompleted(_getCode(controllers));
              }
            },
          ),
        );
      }),
    );
  }

  String _getCode(List<TextEditingController> controllers) {
    return controllers.map((c) => c.text).join();
  }
}

/// Form field wrapper with label and error
class AppFormField extends StatelessWidget {
  final String? label;
  final String? helperText;
  final Widget child;
  final bool isRequired;

  const AppFormField({
    super.key,
    this.label,
    this.helperText,
    required this.child,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                Text(label!, style: AppTypography.titleSmall),
                if (isRequired)
                  Text(' *', style: AppTypography.titleSmall.copyWith(color: AppColors.error)),
              ],
            ),
          ),
        child,
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(helperText!, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
          ),
      ],
    );
  }
}
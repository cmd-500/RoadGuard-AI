import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

class RoadSafeTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final String? counterText;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const RoadSafeTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.counterText,
    this.enabled = true,
    this.focusNode,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: RoadSafeTypography.titleSmall),
          const SizedBox(height: RoadSafeSpacing.xs),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          focusNode: focusNode,
          textInputAction: textInputAction,
          style: RoadSafeTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textTertiary),
            counterText: counterText,
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.all(RoadSafeSpacing.md),
                    child: Icon(prefixIcon, size: 20, color: RoadSafeColors.textTertiary),
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon, size: 20, color: RoadSafeColors.textTertiary),
                    onPressed: onSuffixPressed,
                    padding: const EdgeInsets.all(RoadSafeSpacing.md),
                  )
                : null,
            filled: true,
            fillColor: enabled ? RoadSafeColors.surface : RoadSafeColors.backgroundAlt,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              borderSide: BorderSide(color: RoadSafeColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              borderSide: BorderSide(color: RoadSafeColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              borderSide: BorderSide(color: RoadSafeColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              borderSide: BorderSide(color: RoadSafeColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              borderSide: BorderSide(color: RoadSafeColors.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              borderSide: BorderSide(color: RoadSafeColors.border),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: RoadSafeSpacing.lg,
              vertical: RoadSafeSpacing.md,
            ),
            errorStyle: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.error),
          ),
        ),
      ],
    );
  }
}

class RoadSafeSearchField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onLocationPressed;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingPressed;

  const RoadSafeSearchField({
    super.key,
    this.hint = 'Where do you want to go?',
    this.controller,
    this.onChanged,
    this.onFilterPressed,
    this.onLocationPressed,
    this.trailingIcon,
    this.onTrailingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: RoadSafeColors.surface,
        borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
        border: Border.all(color: RoadSafeColors.border),
        boxShadow: RoadSafeShadows.card,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textTertiary),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(RoadSafeSpacing.md),
            child: Icon(RoadSafeIcons.search, size: 22, color: RoadSafeColors.textTertiary),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onLocationPressed != null)
                IconButton(
                  icon: Icon(RoadSafeIcons.location, size: 22, color: RoadSafeColors.textSecondary),
                  onPressed: onLocationPressed,
                  padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.sm),
                ),
              if (onFilterPressed != null)
                IconButton(
                  icon: Icon(RoadSafeIcons.filter, size: 22, color: RoadSafeColors.textSecondary),
                  onPressed: onFilterPressed,
                  padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.sm),
                ),
              if (trailingIcon != null)
                IconButton(
                  icon: Icon(trailingIcon, size: 22, color: RoadSafeColors.textSecondary),
                  onPressed: onTrailingPressed,
                  padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.sm),
                ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: RoadSafeSpacing.md),
        ),
        style: RoadSafeTypography.bodyMedium,
      ),
    );
  }
}

class RoadSafeDropdownField<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;

  const RoadSafeDropdownField({
    super.key,
    required this.label,
    this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: RoadSafeTypography.titleSmall),
        const SizedBox(height: RoadSafeSpacing.xs),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textTertiary),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.all(RoadSafeSpacing.md),
                    child: Icon(prefixIcon, size: 20, color: RoadSafeColors.textTertiary),
                  )
                : null,
            filled: true,
            fillColor: RoadSafeColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              borderSide: BorderSide(color: RoadSafeColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              borderSide: BorderSide(color: RoadSafeColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              borderSide: BorderSide(color: RoadSafeColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              borderSide: BorderSide(color: RoadSafeColors.error, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: RoadSafeSpacing.lg,
              vertical: RoadSafeSpacing.md,
            ),
          ),
          style: RoadSafeTypography.bodyMedium,
          icon: Icon(RoadSafeIcons.caretDown, size: 20, color: RoadSafeColors.textTertiary),
          dropdownColor: RoadSafeColors.surface,
          borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
        ),
      ],
    );
  }
}

class RoadSafeRadioGroup<T> extends StatelessWidget {
  final String label;
  final List<RoadSafeRadioOption<T>> options;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;

  const RoadSafeRadioGroup({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: RoadSafeTypography.titleSmall),
        const SizedBox(height: RoadSafeSpacing.sm),
        Wrap(
          spacing: RoadSafeSpacing.md,
          runSpacing: RoadSafeSpacing.sm,
          children: options.map((option) {
            final isSelected = selectedValue == option.value;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (option.icon != null) ...[
                    Icon(option.icon, size: 16, color: isSelected ? RoadSafeColors.textOnPrimary : RoadSafeColors.textSecondary),
                    const SizedBox(width: RoadSafeSpacing.xs),
                  ],
                  Text(option.label),
                ],
              ),
              selected: isSelected,
              onSelected: (_) => onChanged(option.value),
              selectedColor: RoadSafeColors.primaryContainer,
              backgroundColor: RoadSafeColors.background,
              labelStyle: RoadSafeTypography.labelMedium.copyWith(
                color: isSelected ? RoadSafeColors.primary : RoadSafeColors.textSecondary,
              ),
              side: BorderSide(
                color: isSelected ? RoadSafeColors.primary : RoadSafeColors.border,
                width: isSelected ? 1.5 : 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(RoadSafeRadius.round),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: RoadSafeSpacing.md,
                vertical: RoadSafeSpacing.sm,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class RoadSafeRadioOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const RoadSafeRadioOption({required this.value, required this.label, this.icon});
}
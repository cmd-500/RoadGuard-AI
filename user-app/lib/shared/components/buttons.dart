import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

/// Primary button - main action
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height = AppSpacing.buttonHeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: AppTypography.buttonLarge),
              if (trailingIcon != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(trailingIcon, size: 18),
              ],
            ],
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: FilledButton(
        onPressed: isDisabled ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
          elevation: 0,
          shadowColor: Colors.transparent,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryDark.withValues(alpha: 0.3);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.primaryDark.withValues(alpha: 0.1);
            }
            return Colors.transparent;
          }),
        ),
        child: child,
      ),
    );
  }
}

/// Secondary button - alternative action
class AppSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;

  const AppSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.borderColor,
    this.textColor,
    this.width,
    this.height = AppSpacing.buttonHeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;
    final effectiveBorderColor = borderColor ?? AppColors.outlineStrong;
    final effectiveTextColor = textColor ?? AppColors.textPrimary;

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18, color: effectiveTextColor),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: AppTypography.buttonLarge.copyWith(color: effectiveTextColor)),
              if (trailingIcon != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(trailingIcon, size: 18, color: effectiveTextColor),
              ],
            ],
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveTextColor,
          side: BorderSide(color: effectiveBorderColor, width: 1.5),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return effectiveBorderColor.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return effectiveBorderColor.withValues(alpha: 0.05);
            }
            return Colors.transparent;
          }),
        ),
        child: child,
      ),
    );
  }
}

/// Tertiary button - subtle action
class AppTertiaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? textColor;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;

  const AppTertiaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.textColor,
    this.width,
    this.height = AppSpacing.buttonHeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final effectiveTextColor = textColor ?? AppColors.primary;

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18, color: effectiveTextColor),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: AppTypography.buttonLarge.copyWith(color: effectiveTextColor)),
              if (trailingIcon != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(trailingIcon, size: 18, color: effectiveTextColor),
              ],
            ],
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: TextButton(
        onPressed: isDisabled ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: effectiveTextColor,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return effectiveTextColor.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return effectiveTextColor.withValues(alpha: 0.05);
            }
            return Colors.transparent;
          }),
        ),
        child: child,
      ),
    );
  }
}

/// Danger button - destructive action
class AppDangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final double? width;
  final double height;

  const AppDangerButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.width,
    this.height = AppSpacing.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.onError),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18, color: AppColors.onError),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: AppTypography.buttonLarge.copyWith(color: AppColors.onError)),
            ],
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: FilledButton(
        onPressed: isDisabled ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.onError,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
          elevation: 0,
          shadowColor: Colors.transparent,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.errorDark.withValues(alpha: 0.3);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.errorDark.withValues(alpha: 0.1);
            }
            return Colors.transparent;
          }),
        ),
        child: child,
      ),
    );
  }
}

/// Icon button with modern styling
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final String? tooltip;
  final bool isSelected;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.iconSize = 20,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.tooltip,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? (isSelected ? AppColors.primaryContainer : AppColors.surface);
    final effectiveIconColor = iconColor ?? (isSelected ? AppColors.primary : AppColors.textSecondary);
    final effectiveBorderColor = borderColor ?? (isSelected ? AppColors.primary : Colors.transparent);

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.buttonSmall),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: effectiveBgColor,
            borderRadius: BorderRadius.circular(AppRadius.buttonSmall),
            border: Border.all(color: effectiveBorderColor, width: 1.5),
          ),
          child: Icon(icon, size: iconSize, color: effectiveIconColor),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}

/// Floating Action Button
class AppFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isExtended;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.isExtended = false,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  const AppFAB.extended({
    super.key,
    required this.icon,
    this.onPressed,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
  }) : isExtended = true;

  @override
  Widget build(BuildContext context) {
    if (isExtended) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: foregroundColor ?? AppColors.onPrimary,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 8,
        highlightElevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.fab),
        ),
        label: Text(label ?? '', style: AppTypography.buttonLarge),
        icon: Icon(icon, size: 24),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.onPrimary,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 8,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.fab),
      ),
      child: Icon(icon, size: 24),
    );
  }
}

/// Segmented control
class AppSegmentedButton<T> extends StatelessWidget {
  final List<AppSegment<T>> segments;
  final T? selectedValue;
  final ValueChanged<T?>? onChanged;

  const AppSegmentedButton({
    super.key,
    required this.segments,
    required this.selectedValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments.map((s) => ButtonSegment<T>(
        value: s.value,
        label: Text(s.label, style: AppTypography.labelMedium),
        icon: s.icon != null ? Icon(s.icon, size: 18) : null,
        tooltip: s.tooltip,
      )).toList(),
      selected: {if (selectedValue != null) selectedValue!},
      onSelectionChanged: (values) {
        if (onChanged != null) {
          onChanged!(values.isEmpty ? null : values.first);
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primaryContainer;
          return AppColors.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.textSecondary;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return BorderSide.none;
          return AppBorders.thin;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        ),
      ),
    );
  }
}

class AppSegment<T> {
  final T value;
  final String label;
  final IconData? icon;
  final String? tooltip;

  const AppSegment({required this.value, required this.label, this.icon, this.tooltip});
}

/// Toggle button (switch-like)
class AppToggleButton extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final IconData? icon;
  final String? tooltip;

  const AppToggleButton({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.icon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onChanged != null ? () => onChanged!(!value) : null,
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: AnimatedContainer(
            duration: AppMotion.fadeIn,
            curve: AppMotion.fadeCurve,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: value ? AppColors.primaryContainer : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(
                color: value ? AppColors.primary : AppColors.outline,
                width: value ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: value ? AppColors.primary : AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    color: value ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: value ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
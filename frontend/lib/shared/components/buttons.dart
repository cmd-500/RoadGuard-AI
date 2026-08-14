import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

class RoadSafePrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const RoadSafePrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(RoadSafeColors.textOnPrimary),
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18, color: RoadSafeColors.textOnPrimary),
                const SizedBox(width: RoadSafeSpacing.inlineSpacing),
              ],
              Text(label, style: RoadSafeTypography.buttonLarge.copyWith(color: RoadSafeColors.textOnPrimary)),
              if (trailingIcon != null) ...[
                const SizedBox(width: RoadSafeSpacing.inlineSpacing),
                Icon(trailingIcon, size: 18, color: RoadSafeColors.textOnPrimary),
              ],
            ],
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: RoadSafeColors.primary,
          foregroundColor: RoadSafeColors.textOnPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
          ),
          padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.xl),
        ),
        child: child,
      ),
    );
  }
}

class RoadSafeSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? borderColor;
  final Color? textColor;

  const RoadSafeSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? RoadSafeColors.primary;
    final effectiveTextColor = textColor ?? RoadSafeColors.primary;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveTextColor,
          side: BorderSide(color: effectiveBorderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
          ),
          padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.xl),
        ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 18, color: effectiveTextColor),
              const SizedBox(width: RoadSafeSpacing.inlineSpacing),
            ],
            Text(label, style: RoadSafeTypography.buttonLarge.copyWith(color: effectiveTextColor)),
            if (trailingIcon != null) ...[
              const SizedBox(width: RoadSafeSpacing.inlineSpacing),
              Icon(trailingIcon, size: 18, color: effectiveTextColor),
            ],
          ],
        ),
      ),
    );
  }
}

class RoadSafeTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? textColor;
  final TextStyle? style;

  const RoadSafeTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.textColor,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? RoadSafeColors.primary;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: effectiveTextColor,
        padding: const EdgeInsets.symmetric(
          horizontal: RoadSafeSpacing.inlineSpacing,
          vertical: RoadSafeSpacing.sm,
        ),
        minimumSize: const Size(0, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 16, color: effectiveTextColor),
            const SizedBox(width: RoadSafeSpacing.xs),
          ],
          Text(
            label,
            style: (style ?? RoadSafeTypography.labelLarge).copyWith(color: effectiveTextColor),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: RoadSafeSpacing.xs),
            Icon(trailingIcon, size: 16, color: effectiveTextColor),
          ],
        ],
      ),
    );
  }
}

class RoadSafeIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final String? tooltip;

  const RoadSafeIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 44,
    this.iconSize = 22,
    this.padding,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackground = backgroundColor ?? RoadSafeColors.surface;
    final effectiveIconColor = iconColor ?? RoadSafeColors.textPrimary;

    Widget button = Material(
      color: effectiveBackground,
      borderRadius: BorderRadius.circular(RoadSafeRadius.round),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(RoadSafeRadius.round),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(icon, size: iconSize, color: effectiveIconColor),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

class RoadSafeFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? label;
  final bool isExtended;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const RoadSafeFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.label,
    this.isExtended = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackground = backgroundColor ?? RoadSafeColors.primary;
    final effectiveForeground = foregroundColor ?? RoadSafeColors.textOnPrimary;

    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: effectiveBackground,
        foregroundColor: effectiveForeground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RoadSafeRadius.round),
        ),
        icon: Icon(icon, size: 22),
        label: Text(label!, style: RoadSafeTypography.buttonMedium.copyWith(color: effectiveForeground)),
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: RoadSafeSpacing.xl,
          vertical: RoadSafeSpacing.md,
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: effectiveBackground,
      foregroundColor: effectiveForeground,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RoadSafeRadius.round),
      ),
      child: Icon(icon, size: 26),
    );
  }
}

class RoadSafeSegmentedButton<T> extends StatelessWidget {
  final List<RoadSafeSegment<T>> segments;
  final T? selectedValue;
  final ValueChanged<T?> onSelectionChanged;
  final bool multiSelect;

  const RoadSafeSegmentedButton({
    super.key,
    required this.segments,
    required this.selectedValue,
    required this.onSelectionChanged,
    this.multiSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments
          .map(
            (s) => ButtonSegment<T>(
              value: s.value,
              label: Text(s.label, style: RoadSafeTypography.labelMedium),
              icon: s.icon != null ? Icon(s.icon, size: 18) : null,
            ),
          )
          .toList(),
      selected: multiSelect
          ? (selectedValue == null ? <T>{} : <T>{selectedValue!})
          : (selectedValue == null ? <T>{} : <T>{selectedValue!}),
      onSelectionChanged: multiSelect
          ? (Set<T> values) => onSelectionChanged(values.isEmpty ? null : values.first)
          : (Set<T> values) => onSelectionChanged(values.isEmpty ? null : values.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return RoadSafeColors.primaryContainer;
          }
          return RoadSafeColors.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return RoadSafeColors.primary;
          }
          return RoadSafeColors.textSecondary;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.selected)) {
            return BorderSide.none;
          }
          return RoadSafeBorders.thin;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(RoadSafeRadius.lg)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: RoadSafeSpacing.lg,
            vertical: RoadSafeSpacing.md,
          ),
        ),
      ),
    );
  }
}

class RoadSafeSegment<T> {
  final T value;
  final String label;
  final IconData? icon;

  const RoadSafeSegment({required this.value, required this.label, this.icon});
}
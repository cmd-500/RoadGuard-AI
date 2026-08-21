import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AppBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.fontSize,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? AppColors.primaryContainer;
    final effectiveTextColor = textColor ?? AppColors.primary;
    final effectiveFontSize = fontSize ?? 10.0;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.badge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: effectiveFontSize + 2, color: effectiveTextColor),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: effectiveFontSize,
              fontWeight: FontWeight.w600,
              height: 1.5,
              letterSpacing: 0.5,
              color: effectiveTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class AppDotBadge extends StatelessWidget {
  final Color color;
  final double size;
  final String? tooltip;

  const AppDotBadge({
    super.key,
    required this.color,
    this.size = 8,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: dot);
    }
    return dot;
  }
}

class AppStatusBadge extends StatelessWidget {
  final String label;
  final AppStatus status;
  final bool showIcon;
  final IconData? customIcon;

  const AppStatusBadge({
    super.key,
    required this.label,
    required this.status,
    this.showIcon = true,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor, icon) = switch (status) {
      AppStatus.success => (AppColors.successLight, AppColors.success, AppIcons.checkCircle),
      AppStatus.warning => (AppColors.warningLight, AppColors.warning, AppIcons.warning),
      AppStatus.error => (AppColors.errorLight, AppColors.error, AppIcons.error),
      AppStatus.info => (AppColors.infoLight, AppColors.info, AppIcons.info),
      AppStatus.pending => (AppColors.infoLight, AppColors.info, AppIcons.pending),
      AppStatus.closed => (AppColors.surfaceContainerLow, AppColors.textTertiary, AppIcons.checkCircle),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(customIcon ?? icon, size: 12, color: textColor),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

enum AppStatus { success, warning, error, info, pending, closed }

class AppSeverityBadge extends StatelessWidget {
  final String severity;
  final bool showIcon;
  final double? fontSize;

  const AppSeverityBadge({
    super.key,
    required this.severity,
    this.showIcon = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.severityColor(severity);
    final lightColor = AppColors.severityLightColor(severity);
    final icon = _getSeverityIcon(severity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: (fontSize ?? 10) + 2, color: color),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            severity.toUpperCase(),
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: fontSize ?? 10,
              fontWeight: FontWeight.w600,
              height: 1.5,
              letterSpacing: 0.5,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
        return AppIcons.warningOctagon;
      case 'HIGH':
        return AppIcons.warningCircle;
      case 'MEDIUM':
        return AppIcons.warning;
      case 'LOW':
        return AppIcons.info;
      case 'INFO':
      case 'INFORMATIONAL':
        return AppIcons.info;
      default:
        return AppIcons.info;
    }
  }
}

class AppHazardBadge extends StatelessWidget {
  final String hazardType;
  final bool showIcon;

  const AppHazardBadge({
    super.key,
    required this.hazardType,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.hazardColor(hazardType);
    final lightColor = AppColors.hazardLightColor(hazardType);
    final icon = _getHazardIcon(hazardType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            _formatHazardType(hazardType),
            style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _formatHazardType(String type) {
    return type
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  IconData _getHazardIcon(String type) {
    switch (type.toUpperCase()) {
      case 'POTHOLE':
        return AppIcons.pothole;
      case 'ACCIDENT':
        return AppIcons.carCrash;
      case 'FOG':
        return AppIcons.cloudFog;
      case 'SPEED_BREAKER':
      case 'UNMARKED_BREAKER':
      case 'ILLEGAL_BREAKER':
        return AppIcons.speedBump;
      case 'WATERLOGGING':
      case 'WATERLOGGED_HAZARD':
        return AppIcons.waves;
      case 'ROAD_DAMAGE':
        return AppIcons.roadHorizon;
      case 'CONSTRUCTION':
        return AppIcons.hammer;
      case 'EMERGENCY':
        return AppIcons.warningCircle;
      default:
        return AppIcons.warning;
    }
  }
}

class AppCountBadge extends StatelessWidget {
  final int count;
  final int maxCount;
  final Color? backgroundColor;
  final Color? textColor;
  final double size;

  const AppCountBadge({
    super.key,
    required this.count,
    this.maxCount = 99,
    this.backgroundColor,
    this.textColor,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    final displayCount = count > maxCount ? '$maxCount+' : count.toString();
    final effectiveBgColor = backgroundColor ?? AppColors.error;
    final effectiveTextColor = textColor ?? AppColors.onError;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      constraints: BoxConstraints(minWidth: size),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(AppRadius.badge),
        border: Border.all(color: AppColors.surface, width: 1.5),
      ),
      child: Text(
        displayCount,
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: size * 0.55,
          fontWeight: FontWeight.w700,
          height: 1,
          color: effectiveTextColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class AppProgressBadge extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? child;

  const AppProgressBadge({
    super.key,
    required this.progress,
    this.size = 40,
    this.strokeWidth = 3,
    this.progressColor,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveProgressColor = progressColor ?? AppColors.primary;
    final effectiveBackgroundColor = backgroundColor ?? AppColors.surfaceContainer;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveProgressColor),
            backgroundColor: effectiveBackgroundColor,
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class AppOutlineBadge extends StatelessWidget {
  final String label;
  final Color? borderColor;
  final Color? textColor;
  final IconData? icon;
  final double? fontSize;

  const AppOutlineBadge({
    super.key,
    required this.label,
    this.borderColor,
    this.textColor,
    this.icon,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppColors.outlineStrong;
    final effectiveTextColor = textColor ?? AppColors.textSecondary;
    final effectiveFontSize = fontSize ?? 10.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        border: Border.all(color: effectiveBorderColor, width: 1),
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: effectiveFontSize + 2, color: effectiveTextColor),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: effectiveFontSize,
              fontWeight: FontWeight.w500,
              height: 1.5,
              letterSpacing: 0.5,
              color: effectiveTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
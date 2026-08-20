import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

/// Base card with elevation and modern styling
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final List<BoxShadow>? shadows;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final bool isHoverable;
  final bool isPressable;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.shadows,
    this.borderRadius,
    this.border,
    this.onTap,
    this.isHoverable = false,
    this.isPressable = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.surface;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppRadius.card);
    final effectiveShadows = shadows ?? (isHoverable ? AppShadows.cardHover : AppShadows.card);
    final effectiveBorder = border ?? Border.all(color: AppColors.outline, width: 1);

    Widget card = Container(
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveBorderRadius,
        boxShadow: effectiveShadows,
        border: effectiveBorder,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          child: child,
        ),
      ),
    );

    if (onTap != null || isHoverable || isPressable) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          hoverColor: AppColors.primaryContainer.withValues(alpha: 0.1),
          highlightColor: AppColors.primaryContainer.withValues(alpha: 0.05),
          splashFactory: isPressable ? InkRipple.splashFactory : NoSplash.splashFactory,
          child: AnimatedContainer(
            duration: AppMotion.fadeIn,
            curve: AppMotion.fadeCurve,
            decoration: BoxDecoration(
              borderRadius: effectiveBorderRadius,
              boxShadow: onTap != null || isPressable ? AppShadows.cardPressed : effectiveShadows,
            ),
            child: card,
          ),
        ),
      );
    }

    return card;
  }
}

/// Card with gradient background
class AppGradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;

  const AppGradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppRadius.card);
    final effectiveShadows = shadows ?? AppShadows.cardElevated;

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: effectiveBorderRadius,
        boxShadow: effectiveShadows,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPaddingLarge),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: card,
        ),
      );
    }

    return card;
  }
}

/// Glassmorphism card
class AppGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool isDark;
  final VoidCallback? onTap;
  final Color? borderColor;

  const AppGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.isDark = false,
    this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppRadius.card);
    final gradient = isDark ? AppColors.glassDark : AppColors.glassLight;
    final effectiveBorderColor = borderColor ?? (isDark ? AppColorsDark.outline : AppColors.outline);

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: effectiveBorderRadius,
        border: Border.all(color: effectiveBorderColor.withValues(alpha: 0.3), width: 1),
        boxShadow: AppShadows.cardElevated,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPaddingLarge),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: card,
        ),
      );
    }

    return card;
  }
}

/// Hazard-specific card for road hazards
class AppHazardCard extends StatelessWidget {
  final String hazardType;
  final String title;
  final String distance;
  final String location;
  final String severity;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool showImage;

  const AppHazardCard({
    super.key,
    required this.hazardType,
    required this.title,
    required this.distance,
    required this.location,
    required this.severity,
    this.imageUrl,
    this.onTap,
    this.showImage = false,
  });

  Color get _hazardColor => AppColors.hazardColor(hazardType);
  Color get _hazardLightColor => AppColors.hazardLightColor(hazardType);
  IconData get _hazardIcon => _getHazardIcon(hazardType);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _hazardLightColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Icon(_hazardIcon, size: 20, color: _hazardColor),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      location,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _SeverityBadge(severity: severity),
            ],
          ),
          if (showImage && imageUrl != null) ...[
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceContainerLow,
                    child: Icon(AppIcons.image, color: AppColors.textTertiary, size: 32),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(AppIcons.location, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                distance,
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const Spacer(),
              if (onTap != null)
                Text(
                  'Tap for details',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                ),
            ],
          ),
        ],
      ),
    );
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

/// Safety alert card
class AppSafetyAlertCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String distance;
  final String severity;
  final String? imageUrl;
  final IconData icon;
  final bool isEmergency;
  final VoidCallback? onTap;

  const AppSafetyAlertCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.distance,
    required this.severity,
    this.imageUrl,
    required this.icon,
    this.isEmergency = false,
    this.onTap,
  });

  Color get _severityColor => AppColors.severityColor(severity);
  Color get _severityLightColor => AppColors.severityLightColor(severity);

  @override
  Widget build(BuildContext context) {
    final borderColor = isEmergency ? AppColors.error : _severityColor;

    return AppCard(
      onTap: onTap,
      border: Border.all(color: borderColor.withValues(alpha: 0.5), width: isEmergency ? 2 : 1),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isEmergency ? AppColors.errorLight : _severityLightColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Icon(icon, size: 20, color: isEmergency ? AppColors.error : _severityColor),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isEmergency) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(AppRadius.badge),
                            ),
                            child: Text(
                              'EMERGENCY',
                              style: AppTypography.overline.copyWith(color: AppColors.onError),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      location,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _SeverityBadge(severity: severity),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: AppTypography.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (imageUrl != null) ...[
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceContainerLow,
                    child: Icon(AppIcons.image, color: AppColors.textTertiary, size: 32),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(AppIcons.location, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                distance,
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Quick action card for home screen - responsive
class AppQuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;
  final bool isLoading;

  const AppQuickActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 80;
        final iconSize = isCompact ? 40.0 : 48.0;
        final iconInnerSize = isCompact ? 18.0 : 22.0;
        final titleStyle = isCompact ? AppTypography.labelSmall : AppTypography.titleSmall;
        final subtitleStyle = isCompact 
            ? AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 9)
            : AppTypography.bodySmall.copyWith(color: AppColors.textSecondary);
        final padding = isCompact ? AppSpacing.xs : AppSpacing.sm;
        final spacing = isCompact ? AppSpacing.xs : AppSpacing.sm;

        return AppCard(
          onTap: onTap,
          isHoverable: true,
          isPressable: true,
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: isLoading
                    ? Center(
                  child: SizedBox(
                    width: iconInnerSize,
                    height: iconInnerSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                    ),
                  ),
                )
                    : Icon(icon, size: iconInnerSize, color: iconColor),
              ),
              SizedBox(height: spacing),
              Flexible(
                child: Text(
                  title,
                  style: titleStyle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: spacing / 2),
              Flexible(
                child: Text(
                  subtitle,
                  style: subtitleStyle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Stat card for profile/dashboard
class AppStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const AppStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor ?? iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTypography.headlineSmall.copyWith(color: iconColor),
                ),
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Info card with icon and message
class AppInfoCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback? onTap;

  const AppInfoCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    this.iconColor,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: backgroundColor,
      border: Border.all(color: borderColor, width: 1),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (iconColor ?? borderColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, size: 20, color: iconColor ?? borderColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(color: titleColor ?? AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge card for achievements
class AppBadgeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool unlocked;
  final Color? unlockedColor;
  final Color? lockedColor;
  final VoidCallback? onTap;

  const AppBadgeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.unlocked,
    this.unlockedColor,
    this.lockedColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveUnlockedColor = unlockedColor ?? AppColors.primary;
    final effectiveLockedColor = lockedColor ?? AppColors.textTertiary;
    final effectiveBgColor = unlocked ? AppColors.primaryContainer : AppColors.surfaceContainerLow;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: effectiveBgColor,
              shape: BoxShape.circle,
              border: unlocked ? null : Border.all(color: AppColors.outline, width: 1.5),
            ),
            child: Icon(icon, size: 32, color: unlocked ? effectiveUnlockedColor : effectiveLockedColor),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: unlocked ? AppColors.textPrimary : AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Menu item card for settings/profile
class AppMenuCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isDestructive;

  const AppMenuCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.onTap,
    this.trailing,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTitleColor = isDestructive ? AppColors.error : AppColors.textPrimary;
    final effectiveIconBgColor = isDestructive ? AppColors.errorLight : iconBackgroundColor;
    final effectiveIconColor = isDestructive ? AppColors.error : iconColor;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: effectiveIconBgColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, size: 22, color: effectiveIconColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium.copyWith(color: effectiveTitleColor)),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
          trailing ?? (onTap != null
              ? Icon(AppIcons.caretRight, size: 20, color: AppColors.textTertiary)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

/// Compact list-row for a live/nearby alert — icon, title, meta line,
/// distance and a chevron on the trailing edge, plus a small risk pill.
/// Used on the Home screen's "Live Alerts" feed.
class AppAlertListItem extends StatelessWidget {
  final String hazardType;
  final String title;
  final String subtitle;
  final String distance;
  final String severity;
  final VoidCallback? onTap;

  const AppAlertListItem({
    super.key,
    required this.hazardType,
    required this.title,
    required this.subtitle,
    required this.distance,
    required this.severity,
    this.onTap,
  });

  String get _riskLabel {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
      case 'HIGH':
        return 'High Risk';
      case 'MEDIUM':
        return 'Medium Risk';
      case 'LOW':
        return 'Low Risk';
      default:
        return 'Info';
    }
  }

  IconData get _icon => _resolveIcon(hazardType);
  Color get _iconColor => AppColors.hazardColor(hazardType);
  Color get _iconBgColor => AppColors.hazardLightColor(hazardType);

  static IconData _resolveIcon(String type) {
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
    // Alert categories (Live Alerts feed)
      case 'ROAD':
        return AppIcons.roadHorizon;
      case 'WEATHER':
        return AppIcons.waves;
      case 'VISIBILITY':
        return AppIcons.cloudFog;
      case 'DISASTER':
        return AppIcons.warningCircle;
      default:
        return AppIcons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = AppColors.severityColor(severity);
    final riskLightColor = AppColors.severityLightColor(severity);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, size: 20, color: _iconColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: riskLightColor,
                    borderRadius: BorderRadius.circular(AppRadius.badge),
                  ),
                  child: Text(
                    _riskLabel.toUpperCase(),
                    style: AppTypography.overline.copyWith(color: riskColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                distance,
                style: AppTypography.labelMedium.copyWith(
                  color: riskColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Icon(AppIcons.caretRight, size: 16, color: AppColors.textTertiary),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  final String severity;

  const _SeverityBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.severityColor(severity);
    final lightColor = AppColors.severityLightColor(severity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Text(
        severity.toUpperCase(),
        style: AppTypography.overline.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
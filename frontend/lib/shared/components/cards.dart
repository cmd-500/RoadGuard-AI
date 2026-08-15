import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

class RoadSafeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final List<BoxShadow>? shadows;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;

  const RoadSafeCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.shadows,
    this.borderRadius,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: color ?? RoadSafeColors.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(RoadSafeRadius.xl),
        border: border,
        boxShadow: shadows ?? RoadSafeShadows.card,
      ),
      padding: padding ?? const EdgeInsets.all(RoadSafeSpacing.cardPadding),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(RoadSafeRadius.xl),
          child: card,
        ),
      );
    }

    return card;
  }
}

class RoadSafeElevatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const RoadSafeElevatedCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoadSafeCard(
      child: child,
      padding: padding,
      color: color,
      borderRadius: borderRadius,
      shadows: RoadSafeShadows.cardElevated,
      onTap: onTap,
    );
  }
}

class RoadSafeOutlinedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final VoidCallback? onTap;

  const RoadSafeOutlinedCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
    this.borderSide,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoadSafeCard(
      child: child,
      padding: padding,
      color: color,
      borderRadius: borderRadius,
      border: Border.all(
        color: borderSide?.color ?? RoadSafeColors.border,
        width: borderSide?.width ?? 1.0,
      ),
      shadows: null,
      onTap: onTap,
    );
  }
}

class RoadSafeQuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const RoadSafeQuickActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoadSafeCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: RoadSafeSpacing.md,
        vertical: RoadSafeSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(height: RoadSafeSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: RoadSafeTypography.titleMedium,
          ),
          const SizedBox(height: RoadSafeSpacing.xs),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: RoadSafeTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}

class RoadSafeHazardCard extends StatelessWidget {
  final String hazardType;
  final String title;
  final String distance;
  final String location;
  final String severity;
  final String? imageUrl;
  final VoidCallback? onTap;
  final IconData? hazardIcon;

  const RoadSafeHazardCard({
    super.key,
    required this.hazardType,
    required this.title,
    required this.distance,
    required this.location,
    required this.severity,
    this.imageUrl,
    this.onTap,
    this.hazardIcon,
  });

  @override
  Widget build(BuildContext context) {
    final severityColor = RoadSafeColors.severityColor(severity);
    final severityBackground = RoadSafeColors.severityBackground(severity);

    return RoadSafeCard(
      onTap: onTap,
      padding: const EdgeInsets.all(RoadSafeSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null && imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(RoadSafeRadius.md),
              child: Image.network(
                imageUrl!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildHazardIconPlaceholder(),
              ),
            )
          else
            _buildHazardIconPlaceholder(),
          const SizedBox(width: RoadSafeSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildHazardIcon(hazardIcon),
                    const SizedBox(width: RoadSafeSpacing.sm),
                    Expanded(
                      child: Text(
                        title,
                        style: RoadSafeTypography.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RoadSafeSpacing.xs),
                Row(
                  children: [
                    Icon(RoadSafeIcons.mapPin, size: 14, color: RoadSafeColors.textTertiary),
                    const SizedBox(width: RoadSafeSpacing.xs),
                    Expanded(
                      child: Text(
                        location,
                        style: RoadSafeTypography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RoadSafeSpacing.xs),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: RoadSafeSpacing.md,
                  runSpacing: RoadSafeSpacing.xs,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(RoadSafeIcons.navigation, size: 14, color: RoadSafeColors.textTertiary),
                        const SizedBox(width: RoadSafeSpacing.xs),
                        Text(
                          distance,
                          style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: RoadSafeSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: severityBackground,
                        borderRadius: BorderRadius.circular(RoadSafeRadius.round),
                      ),
                      child: Text(
                        severity,
                        style: RoadSafeTypography.labelSmall.copyWith(
                          color: severityColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(RoadSafeIcons.caretRight, size: 20, color: RoadSafeColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildHazardIconPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: RoadSafeColors.backgroundAlt,
        borderRadius: BorderRadius.circular(RoadSafeRadius.md),
      ),
      child: _buildHazardIcon(hazardIcon),
    );
  }

  Widget _buildHazardIcon(IconData? icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: RoadSafeColors.primaryContainer,
        borderRadius: BorderRadius.circular(RoadSafeRadius.md),
      ),
      child: Icon(
        icon ?? _getDefaultHazardIcon(hazardType),
        size: 22,
        color: RoadSafeColors.primary,
      ),
    );
  }

  IconData _getDefaultHazardIcon(String hazardType) {
    switch (hazardType.toUpperCase()) {
      case 'POTHOLE':
        return RoadSafeIcons.pothole;
      case 'ACCIDENT':
        return RoadSafeIcons.carCrash;
      case 'FOG':
        return RoadSafeIcons.cloudFog;
      case 'SPEED_BREAKER':
      case 'UNMARKED_BREAKER':
      case 'ILLEGAL_BREAKER':
        return RoadSafeIcons.speedBump;
      case 'WATERLOGGING':
      case 'WATERLOGGED_HAZARD':
        return RoadSafeIcons.waves;
      case 'ROAD_DAMAGE':
        return RoadSafeIcons.roadHorizon;
      case 'CONSTRUCTION':
        return RoadSafeIcons.hammer;
      case 'EMERGENCY':
        return RoadSafeIcons.warningCircle;
      default:
        return RoadSafeIcons.warning;
    }
  }
}

class RoadSafeReportCard extends StatelessWidget {
  final String title;
  final String hazardType;
  final String location;
  final String dateTime;
  final String status;
  final String statusMessage;
  final String? imageUrl;
  final VoidCallback? onTap;

  const RoadSafeReportCard({
    super.key,
    required this.title,
    required this.hazardType,
    required this.location,
    required this.dateTime,
    required this.status,
    required this.statusMessage,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);
    final statusBackground = _getStatusBackground(status);

    return RoadSafeCard(
      onTap: onTap,
      padding: const EdgeInsets.all(RoadSafeSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null && imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(RoadSafeRadius.md),
              child: Image.network(
                imageUrl!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              ),
            )
          else
            _buildPlaceholder(),
          const SizedBox(width: RoadSafeSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: RoadSafeTypography.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: RoadSafeSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusBackground,
                        borderRadius: BorderRadius.circular(RoadSafeRadius.round),
                      ),
                      child: Text(
                        status,
                        style: RoadSafeTypography.labelSmall.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RoadSafeSpacing.xs),
                Row(
                  children: [
                    _getHazardIcon(hazardType),
                    const SizedBox(width: RoadSafeSpacing.xs),
                    Flexible(
                      child: Text(
                        hazardType,
                        style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: RoadSafeSpacing.md),
                    Icon(RoadSafeIcons.calendar, size: 14, color: RoadSafeColors.textTertiary),
                    const SizedBox(width: RoadSafeSpacing.xs),
                    Text(
                      dateTime,
                      style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: RoadSafeSpacing.xs),
                Row(
                  children: [
                    Icon(RoadSafeIcons.mapPin, size: 14, color: RoadSafeColors.textTertiary),
                    const SizedBox(width: RoadSafeSpacing.xs),
                    Expanded(
                      child: Text(
                        location,
                        style: RoadSafeTypography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RoadSafeSpacing.sm),
                Text(
                  statusMessage,
                  style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(RoadSafeIcons.caretRight, size: 20, color: RoadSafeColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: RoadSafeColors.backgroundAlt,
        borderRadius: BorderRadius.circular(RoadSafeRadius.md),
      ),
      child: _getHazardIcon(hazardType),
    );
  }

  Widget _getHazardIcon(String hazardType) {
    IconData icon;
    switch (hazardType.toUpperCase()) {
      case 'POTHOLE':
        icon = RoadSafeIcons.pothole;
        break;
      case 'ACCIDENT':
        icon = RoadSafeIcons.carCrash;
        break;
      case 'FOG':
        icon = RoadSafeIcons.cloudFog;
        break;
      case 'SPEED_BREAKER':
      case 'UNMARKED_BREAKER':
      case 'ILLEGAL_BREAKER':
        icon = RoadSafeIcons.speedBump;
        break;
      case 'WATERLOGGING':
      case 'WATERLOGGED_HAZARD':
        icon = RoadSafeIcons.waves;
        break;
      case 'ROAD_DAMAGE':
        icon = RoadSafeIcons.roadHorizon;
        break;
      case 'CONSTRUCTION':
        icon = RoadSafeIcons.hammer;
        break;
      case 'EMERGENCY':
        icon = RoadSafeIcons.warningCircle;
        break;
      default:
        icon = RoadSafeIcons.warning;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: RoadSafeColors.primaryContainer,
        borderRadius: BorderRadius.circular(RoadSafeRadius.md),
      ),
      child: Icon(icon, size: 22, color: RoadSafeColors.primary),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return RoadSafeColors.informational;
      case 'IN PROGRESS':
      case 'IN_PROGRESS':
        return RoadSafeColors.warning;
      case 'RESOLVED':
        return RoadSafeColors.success;
      case 'CLOSED':
        return RoadSafeColors.textTertiary;
      case 'REJECTED':
        return RoadSafeColors.error;
      default:
        return RoadSafeColors.textSecondary;
    }
  }

  Color _getStatusBackground(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return RoadSafeColors.informationalLight;
      case 'IN PROGRESS':
      case 'IN_PROGRESS':
        return RoadSafeColors.warningLight;
      case 'RESOLVED':
        return RoadSafeColors.successLight;
      case 'CLOSED':
        return RoadSafeColors.backgroundAlt;
      case 'REJECTED':
        return RoadSafeColors.errorLight;
      default:
        return RoadSafeColors.backgroundAlt;
    }
  }
}

class RoadSafeSafetyAlertCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String distance;
  final String severity;
  final String? imageUrl;
  final IconData? icon;
  final bool isEmergency;

  const RoadSafeSafetyAlertCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.distance,
    required this.severity,
    this.imageUrl,
    this.icon,
    this.isEmergency = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isEmergency ? RoadSafeColors.errorLight : RoadSafeColors.surface;
    final borderColor = isEmergency ? RoadSafeColors.error : RoadSafeColors.border;
    final titleColor = isEmergency ? RoadSafeColors.error : RoadSafeColors.textPrimary;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(RoadSafeRadius.xl),
        border: Border.all(color: borderColor, width: isEmergency ? 2 : 1),
        boxShadow: isEmergency ? RoadSafeShadows.cardElevated : RoadSafeShadows.card,
      ),
      padding: const EdgeInsets.all(RoadSafeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isEmergency)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: RoadSafeSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: RoadSafeColors.errorLight,
                borderRadius: BorderRadius.circular(RoadSafeRadius.round),
              ),
              child: Text(
                'EMERGENCY ALERT',
                style: RoadSafeTypography.labelSmall.copyWith(
                  color: RoadSafeColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (isEmergency) const SizedBox(height: RoadSafeSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(RoadSafeRadius.md),
                  child: Image.network(
                    imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: RoadSafeSpacing.lg),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (icon != null)
                          Icon(icon, size: 20, color: titleColor),
                        if (icon != null) const SizedBox(width: RoadSafeSpacing.xs),
                        Expanded(
                          child: Text(
                            title,
                            style: RoadSafeTypography.titleMedium.copyWith(color: titleColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: RoadSafeSpacing.xs),
                    Text(
                      description,
                      style: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textSecondary),
                    ),
                    const SizedBox(height: RoadSafeSpacing.sm),
                    Wrap(
                      spacing: RoadSafeSpacing.md,
                      runSpacing: RoadSafeSpacing.xs,
                      children: [
                        _buildInfoChip(RoadSafeIcons.mapPin, location),
                        _buildInfoChip(RoadSafeIcons.navigation, distance),
                        _buildSeverityChip(severity),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RoadSafeSpacing.sm,
        vertical: RoadSafeSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: RoadSafeColors.backgroundAlt,
        borderRadius: BorderRadius.circular(RoadSafeRadius.round),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: RoadSafeColors.textSecondary),
          const SizedBox(width: RoadSafeSpacing.xs),
          Text(label, style: RoadSafeTypography.caption.copyWith(color: RoadSafeColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSeverityChip(String severity) {
    final color = RoadSafeColors.severityColor(severity);
    final bgColor = RoadSafeColors.severityBackground(severity);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RoadSafeSpacing.sm,
        vertical: RoadSafeSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(RoadSafeRadius.round),
      ),
      child: Text(
        severity,
        style: RoadSafeTypography.caption.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class RoadSafeInfoCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onDismiss;

  const RoadSafeInfoCard({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? RoadSafeColors.informationalLight;
    final effectiveBorder = borderColor ?? RoadSafeColors.informational;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
        border: Border.all(color: effectiveBorder, width: 1),
      ),
      padding: const EdgeInsets.all(RoadSafeSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: effectiveBorder.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(RoadSafeRadius.md),
              ),
              child: Icon(icon, size: 18, color: effectiveBorder),
            ),
            const SizedBox(width: RoadSafeSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: RoadSafeTypography.titleSmall.copyWith(color: effectiveBorder)),
                const SizedBox(height: RoadSafeSpacing.xs),
                Text(message, style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary)),
              ],
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(RoadSafeIcons.close, size: 18, color: RoadSafeColors.textTertiary),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
        ],
      ),
    );
  }
}

class RoadSafeStatusTimeline extends StatelessWidget {
  final List<RoadSafeTimelineItem> items;
  final int currentIndex;

  const RoadSafeStatusTimeline({
    super.key,
    required this.items,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == items.length - 1;
        final isCurrent = index == currentIndex;
        final isCompleted = index < currentIndex;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted || isCurrent
                        ? RoadSafeColors.primary
                        : RoadSafeColors.backgroundAlt,
                    borderRadius: BorderRadius.circular(RoadSafeRadius.round),
                    border: Border.all(
                      color: isCompleted || isCurrent ? RoadSafeColors.primary : RoadSafeColors.border,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? Icon(RoadSafeIcons.check, size: 14, color: RoadSafeColors.textOnPrimary)
                      : (isCurrent
                      ? Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: RoadSafeColors.textOnPrimary,
                      borderRadius: BorderRadius.circular(RoadSafeRadius.round),
                    ),
                  )
                      : null),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted ? RoadSafeColors.primary : RoadSafeColors.border,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: RoadSafeSpacing.lg),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : RoadSafeSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: RoadSafeTypography.titleMedium.copyWith(
                              color: isCurrent || isCompleted
                                  ? RoadSafeColors.textPrimary
                                  : RoadSafeColors.textSecondary,
                              fontWeight: isCurrent || isCompleted ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: RoadSafeSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: RoadSafeSpacing.xs,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: RoadSafeColors.primaryContainer,
                              borderRadius: BorderRadius.circular(RoadSafeRadius.round),
                            ),
                            child: Text(
                              'CURRENT',
                              style: RoadSafeTypography.labelSmall.copyWith(
                                color: RoadSafeColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: RoadSafeSpacing.xs),
                    Text(
                      item.description,
                      style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                    ),
                    const SizedBox(height: RoadSafeSpacing.xs),
                    Text(
                      item.timestamp,
                      style: RoadSafeTypography.caption.copyWith(color: RoadSafeColors.textTertiary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class RoadSafeTimelineItem {
  final String title;
  final String description;
  final String timestamp;

  const RoadSafeTimelineItem({
    required this.title,
    required this.description,
    required this.timestamp,
  });
}
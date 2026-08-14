import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

class RoadSafeBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const RoadSafeBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.padding,
    this.borderRadius = RoadSafeRadius.round,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: RoadSafeSpacing.sm,
            vertical: 2,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? RoadSafeColors.primaryContainer,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor ?? RoadSafeColors.primary),
            const SizedBox(width: RoadSafeSpacing.xs),
          ],
          Text(
            label,
            style: RoadSafeTypography.labelSmall.copyWith(
              color: textColor ?? RoadSafeColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class RoadSafeSeverityBadge extends StatelessWidget {
  final String severity;
  final bool showIcon;

  const RoadSafeSeverityBadge({
    super.key,
    required this.severity,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = RoadSafeColors.severityColor(severity);
    final background = RoadSafeColors.severityBackground(severity);
    final icon = _getSeverityIcon(severity);

    return RoadSafeBadge(
      label: severity,
      backgroundColor: background,
      textColor: color,
      icon: showIcon ? icon : null,
    );
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
        return RoadSafeIcons.warningCircle;
      case 'HIGH':
        return RoadSafeIcons.warning;
      case 'MEDIUM':
        return RoadSafeIcons.info;
      case 'LOW':
        return RoadSafeIcons.checkCircle;
      default:
        return RoadSafeIcons.help;
    }
  }
}

class RoadSafeHazardTypeBadge extends StatelessWidget {
  final String hazardType;
  final bool showIcon;

  const RoadSafeHazardTypeBadge({
    super.key,
    required this.hazardType,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = RoadSafeColors.hazardColor(hazardType);
    final background = color.withValues(alpha: 0.12);
    final icon = _getHazardIcon(hazardType);

    return RoadSafeBadge(
      label: _getHazardLabel(hazardType),
      backgroundColor: background,
      textColor: color,
      icon: showIcon ? icon : null,
    );
  }

  IconData _getHazardIcon(String hazardType) {
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

  String _getHazardLabel(String hazardType) {
    switch (hazardType.toUpperCase()) {
      case 'POTHOLE':
        return 'Pothole';
      case 'ACCIDENT':
        return 'Accident';
      case 'FOG':
        return 'Fog';
      case 'SPEED_BREAKER':
        return 'Speed Breaker';
      case 'UNMARKED_BREAKER':
        return 'Unmarked Breaker';
      case 'ILLEGAL_BREAKER':
        return 'Illegal Breaker';
      case 'WATERLOGGING':
      case 'WATERLOGGED_HAZARD':
        return 'Waterlogging';
      case 'ROAD_DAMAGE':
        return 'Road Damage';
      case 'CONSTRUCTION':
        return 'Construction';
      case 'EMERGENCY':
        return 'Emergency';
      default:
        return hazardType;
    }
  }
}

class RoadSafeStatusBadge extends StatelessWidget {
  final String status;
  final bool showIcon;

  const RoadSafeStatusBadge({
    super.key,
    required this.status,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    Color background;
    Color textColor;
    IconData? icon;

    switch (status.toUpperCase()) {
      case 'OPEN':
        background = RoadSafeColors.informationalLight;
        textColor = RoadSafeColors.informational;
        icon = RoadSafeIcons.circle;
        break;
      case 'IN PROGRESS':
      case 'IN_PROGRESS':
        background = RoadSafeColors.warningLight;
        textColor = RoadSafeColors.warning;
        icon = RoadSafeIcons.spinner;
        break;
      case 'RESOLVED':
        background = RoadSafeColors.successLight;
        textColor = RoadSafeColors.success;
        icon = RoadSafeIcons.checkCircle;
        break;
      case 'CLOSED':
        background = RoadSafeColors.backgroundAlt;
        textColor = RoadSafeColors.textTertiary;
        icon = RoadSafeIcons.lock;
        break;
      case 'REJECTED':
        background = RoadSafeColors.errorLight;
        textColor = RoadSafeColors.error;
        icon = RoadSafeIcons.xCircle;
        break;
      default:
        background = RoadSafeColors.backgroundAlt;
        textColor = RoadSafeColors.textSecondary;
        icon = null;
    }

    return RoadSafeBadge(
      label: status,
      backgroundColor: background,
      textColor: textColor,
      icon: showIcon ? icon : null,
    );
  }
}

class RoadSafeRiskBadge extends StatelessWidget {
  final String risk;
  final bool showIcon;

  const RoadSafeRiskBadge({
    super.key,
    required this.risk,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    Color background;
    Color textColor;
    IconData? icon;

    switch (risk.toUpperCase()) {
      case 'HIGH RISK':
      case 'HIGH':
        background = RoadSafeColors.criticalLight;
        textColor = RoadSafeColors.critical;
        icon = RoadSafeIcons.warningCircle;
        break;
      case 'MEDIUM RISK':
      case 'MEDIUM':
        background = RoadSafeColors.warningLight;
        textColor = RoadSafeColors.warning;
        icon = RoadSafeIcons.warning;
        break;
      case 'LOW RISK':
      case 'LOW':
        background = RoadSafeColors.successLight;
        textColor = RoadSafeColors.success;
        icon = RoadSafeIcons.checkCircle;
        break;
      case 'LOW VISIBILITY':
        background = RoadSafeColors.informationalLight;
        textColor = RoadSafeColors.informational;
        icon = RoadSafeIcons.eyeClosed;
        break;
      default:
        background = RoadSafeColors.backgroundAlt;
        textColor = RoadSafeColors.textSecondary;
        icon = null;
    }

    return RoadSafeBadge(
      label: risk,
      backgroundColor: background,
      textColor: textColor,
      icon: showIcon ? icon : null,
    );
  }
}

class RoadSafeCommunityStatusBadge extends StatelessWidget {
  final String status;

  const RoadSafeCommunityStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color background;
    Color textColor;
    IconData? icon;

    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        background = RoadSafeColors.successLight;
        textColor = RoadSafeColors.success;
        icon = RoadSafeIcons.checkCircle;
        break;
      case 'DISPUTED':
        background = RoadSafeColors.errorLight;
        textColor = RoadSafeColors.error;
        icon = RoadSafeIcons.xCircle;
        break;
      case 'UNVERIFIED':
      default:
        background = RoadSafeColors.warningLight;
        textColor = RoadSafeColors.warning;
        icon = RoadSafeIcons.question;
        break;
    }

    return RoadSafeBadge(
      label: status,
      backgroundColor: background,
      textColor: textColor,
      icon: icon,
    );
  }
}
import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

/// Consistent colored-circle hazard icon used on Home, Map markers,
/// Report category picker, My Reports cards and Issue Tracking.
/// Centralizing this in one widget means hazard iconography only
/// ever needs to be updated in one place (see spec requirement #19).
enum RoadSafeHazardIconSize { small, medium, large }

class RoadSafeHazardIcon extends StatelessWidget {
  final String hazardType;
  final RoadSafeHazardIconSize size;
  final bool withSurfaceBorder;

  const RoadSafeHazardIcon({
    super.key,
    required this.hazardType,
    this.size = RoadSafeHazardIconSize.medium,
    this.withSurfaceBorder = false,
  });

  static const Map<String, IconData> _iconMap = {
    'POTHOLE': RoadSafeIcons.pothole,
    'ACCIDENT': RoadSafeIcons.carCrash,
    'FOG': RoadSafeIcons.cloudFog,
    'SPEED_BREAKER': RoadSafeIcons.speedBump,
    'UNMARKED_BREAKER': RoadSafeIcons.speedBump,
    'ILLEGAL_BREAKER': RoadSafeIcons.speedBump,
    'WATERLOGGING': RoadSafeIcons.waves,
    'WATERLOGGED_HAZARD': RoadSafeIcons.waves,
    'ROAD_DAMAGE': RoadSafeIcons.roadHorizon,
    'CONSTRUCTION': RoadSafeIcons.construction,
    'EMERGENCY': RoadSafeIcons.warningOctagon,
    'OTHER': RoadSafeIcons.warningCircle,
  };

  IconData get _icon => _iconMap[hazardType.toUpperCase()] ?? RoadSafeIcons.warning;

  double get _boxSize => switch (size) {
        RoadSafeHazardIconSize.small => 32.0,
        RoadSafeHazardIconSize.medium => 44.0,
        RoadSafeHazardIconSize.large => 56.0,
      };

  double get _iconSize => switch (size) {
        RoadSafeHazardIconSize.small => 16.0,
        RoadSafeHazardIconSize.medium => 22.0,
        RoadSafeHazardIconSize.large => 28.0,
      };

  @override
  Widget build(BuildContext context) {
    final color = RoadSafeColors.hazardColor(hazardType);
    return Container(
      width: _boxSize,
      height: _boxSize,
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        shape: BoxShape.circle,
        border: withSurfaceBorder ? Border.all(color: RoadSafeColors.surface, width: 2) : null,
      ),
      child: Icon(_icon, size: _iconSize, color: color),
    );
  }
}

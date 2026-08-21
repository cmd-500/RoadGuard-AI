import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';
import 'badges.dart';

/// Normalizes a hazard type string (camelCase, snake_case, spaced, etc.)
/// into a consistent key like 'ROADDAMAGE' so icon/color lookups work
/// no matter which format the caller passes in.
String normalizeHazardKey(String s) {
  return s.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
}

class AppHazardIcon extends StatelessWidget {
  final String hazardType;
  final AppHazardIconSize size;
  final bool showBackground;
  final Color? customColor;
  final VoidCallback? onTap;

  const AppHazardIcon({
    super.key,
    required this.hazardType,
    this.size = AppHazardIconSize.medium,
    this.showBackground = true,
    this.customColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = customColor ?? AppColors.hazardColor(hazardType);
    final lightColor = AppColors.hazardLightColor(hazardType);
    final iconData = _getHazardIcon(hazardType);
    final (iconSize, containerSize) = _getSizes();

    Widget icon = Icon(iconData, size: iconSize, color: color);

    if (showBackground) {
      icon = Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: size == AppHazardIconSize.large ? AppShadows.card : null,
        ),
        child: Center(child: icon),
      );
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: icon,
        ),
      );
    }

    return icon;
  }

  (double, double) _getSizes() {
    switch (size) {
      case AppHazardIconSize.small:
        return (16.0, 32.0);
      case AppHazardIconSize.medium:
        return (24.0, 48.0);
      case AppHazardIconSize.large:
        return (32.0, 64.0);
      case AppHazardIconSize.xlarge:
        return (40.0, 80.0);
    }
  }

  IconData _getHazardIcon(String type) {
    switch (normalizeHazardKey(type)) {
      case 'POTHOLE':
        return AppIcons.pothole;
      case 'ACCIDENT':
        return AppIcons.carCrash;
      case 'FOG':
        return AppIcons.cloudFog;
      case 'SPEEDBREAKER':
      case 'UNMARKEDBREAKER':
      case 'ILLEGALBREAKER':
        return AppIcons.speedBump;
      case 'WATERLOGGING':
      case 'WATERLOGGEDHAZARD':
        return AppIcons.waves;
      case 'ROADDAMAGE':
        return AppIcons.roadHorizon;
      case 'CONSTRUCTION':
        return AppIcons.hammer;
      case 'EMERGENCY':
        return AppIcons.warningCircle;
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
}

enum AppHazardIconSize { small, medium, large, xlarge }

class AppSeverityIndicator extends StatelessWidget {
  final String severity;
  final double size;
  final bool showLabel;
  final TextStyle? labelStyle;

  const AppSeverityIndicator({
    super.key,
    required this.severity,
    this.size = 12,
    this.showLabel = false,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.severityColor(severity);

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            severity.toUpperCase(),
            style: labelStyle ?? AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class AppStatusIndicator extends StatefulWidget {
  final AppStatus status;
  final double size;
  final bool pulse;

  const AppStatusIndicator({
    super.key,
    required this.status,
    this.size = 12,
    this.pulse = false,
  });

  @override
  State<AppStatusIndicator> createState() => _AppStatusIndicatorState();
}

class _AppStatusIndicatorState extends State<AppStatusIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.pulse) {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      )..repeat(reverse: true);
      _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (color, shouldPulse) = switch (widget.status) {
      AppStatus.success => (AppColors.success, false),
      AppStatus.warning => (AppColors.warning, false),
      AppStatus.error => (AppColors.error, widget.pulse),
      AppStatus.info => (AppColors.info, false),
      AppStatus.pending => (AppColors.info, widget.pulse),
      AppStatus.closed => (AppColors.textTertiary, false),
    };

    Widget indicator = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

    if (shouldPulse) {
      indicator = AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(opacity: _animation.value, child: indicator);
        },
      );
    }

    return indicator;
  }
}

class AppHazardChip extends StatelessWidget {
  final String hazardType;
  final bool selected;
  final VoidCallback? onTap;
  final bool enabled;

  const AppHazardChip({
    super.key,
    required this.hazardType,
    required this.selected,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.hazardColor(hazardType);
    final lightColor = AppColors.hazardLightColor(hazardType);
    final icon = _getHazardIcon(hazardType);
    final label = _formatHazardType(hazardType);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: AppMotion.fadeIn,
        curve: AppMotion.fadeCurve,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? lightColor : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: selected ? color : (enabled ? AppColors.outline : AppColors.outlineVariant),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected ? AppShadows.primaryGlowSubtle : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: selected ? color : (enabled ? AppColors.textSecondary : AppColors.textDisabled)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: selected ? color : (enabled ? AppColors.textSecondary : AppColors.textDisabled),
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatHazardType(String type) {
    // Split camelCase / snake_case / already-spaced input into words.
    final spaced = type
        .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}')
        .replaceAll('_', ' ')
        .trim();
    return spaced
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  IconData _getHazardIcon(String type) {
    switch (normalizeHazardKey(type)) {
      case 'POTHOLE':
        return AppIcons.pothole;
      case 'ACCIDENT':
        return AppIcons.carCrash;
      case 'FOG':
        return AppIcons.cloudFog;
      case 'SPEEDBREAKER':
      case 'UNMARKEDBREAKER':
      case 'ILLEGALBREAKER':
        return AppIcons.speedBump;
      case 'WATERLOGGING':
      case 'WATERLOGGEDHAZARD':
        return AppIcons.waves;
      case 'ROADDAMAGE':
        return AppIcons.roadHorizon;
      case 'CONSTRUCTION':
        return AppIcons.hammer;
      case 'EMERGENCY':
        return AppIcons.warningCircle;
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
}

class AppHazardMarker extends StatelessWidget {
  final String hazardType;
  final double size;
  final bool showLabel;
  final String? label;
  final VoidCallback? onTap;

  const AppHazardMarker({
    super.key,
    required this.hazardType,
    this.size = 40,
    this.showLabel = false,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.hazardColor(hazardType);
    final icon = _getHazardIcon(hazardType);

    Widget marker = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surface, width: 2),
            boxShadow: AppShadows.card,
          ),
          child: Icon(icon, size: size * 0.5, color: AppColors.onPrimary),
        ),
        if (showLabel && label != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(AppRadius.badge),
              boxShadow: AppShadows.card,
            ),
            child: Text(label!, style: AppTypography.caption.copyWith(color: AppColors.surface)),
          ),
        ],
      ],
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: marker);
    }

    return marker;
  }

  IconData _getHazardIcon(String type) {
    switch (normalizeHazardKey(type)) {
      case 'POTHOLE':
        return AppIcons.pothole;
      case 'ACCIDENT':
        return AppIcons.carCrash;
      case 'FOG':
        return AppIcons.cloudFog;
      case 'SPEEDBREAKER':
      case 'UNMARKEDBREAKER':
      case 'ILLEGALBREAKER':
        return AppIcons.speedBump;
      case 'WATERLOGGING':
      case 'WATERLOGGEDHAZARD':
        return AppIcons.waves;
      case 'ROADDAMAGE':
        return AppIcons.roadHorizon;
      case 'CONSTRUCTION':
        return AppIcons.hammer;
      case 'EMERGENCY':
        return AppIcons.warningCircle;
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
}

class AppCurrentLocationMarker extends StatelessWidget {
  final double size;
  final bool pulsing;

  const AppCurrentLocationMarker({
    super.key,
    this.size = 48,
    this.pulsing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (pulsing) _buildPulse(size * 1.5, 0),
        if (pulsing) _buildPulse(size * 2.0, 500),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surface, width: 3),
            boxShadow: AppShadows.fab,
          ),
          child: Icon(AppIcons.mapPin, size: size * 0.5, color: AppColors.onPrimary),
        ),
      ],
    );
  }

  Widget _buildPulse(double size, int delay) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        return _PulseAnimation(size: size, color: AppColors.primary);
      },
    );
  }
}

class _PulseAnimation extends StatefulWidget {
  final double size;
  final Color color;

  const _PulseAnimation({required this.size, required this.color});

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - _controller.value,
          child: Transform.scale(
            scale: _controller.value * 1.5 + 0.5,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
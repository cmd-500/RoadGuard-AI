import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

class RoadSafeStepProgress extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final Color? activeColor;
  final Color? inactiveColor;

  const RoadSafeStepProgress({
    super.key,
    required this.steps,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActive = activeColor ?? RoadSafeColors.primary;
    final effectiveInactive = inactiveColor ?? RoadSafeColors.textTertiary;

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isActive = index <= currentStep;
        final isCurrent = index == currentStep;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              _StepCircle(
                number: index + 1,
                isActive: isActive,
                isCurrent: isCurrent,
                activeColor: effectiveActive,
                inactiveColor: effectiveInactive,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.sm),
                    color: index < currentStep ? effectiveActive : effectiveInactive,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int number;
  final bool isActive;
  final bool isCurrent;
  final Color activeColor;
  final Color inactiveColor;

  const _StepCircle({
    required this.number,
    required this.isActive,
    required this.isCurrent,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive ? activeColor : RoadSafeColors.backgroundAlt,
        borderRadius: BorderRadius.circular(RoadSafeRadius.round),
        border: Border.all(
          color: isActive ? activeColor : inactiveColor,
          width: 2,
        ),
      ),
      child: Center(
        child: isActive && !isCurrent
            ? Icon(RoadSafeIcons.check, size: 14, color: RoadSafeColors.textOnPrimary)
            : Text(
                '$number',
                style: RoadSafeTypography.labelMedium.copyWith(
                  color: isActive ? RoadSafeColors.textOnPrimary : inactiveColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

class RoadSafeStepLabels extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final Color? activeColor;
  final Color? inactiveColor;

  const RoadSafeStepLabels({
    super.key,
    required this.steps,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActive = activeColor ?? RoadSafeColors.primary;
    final effectiveInactive = inactiveColor ?? RoadSafeColors.textTertiary;

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isActive = index <= currentStep;

        return Expanded(
          child: Text(
            step,
            textAlign: TextAlign.center,
            style: RoadSafeTypography.labelSmall.copyWith(
              color: isActive ? effectiveActive : effectiveInactive,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class RoadSafeCombinedProgress extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final Color? activeColor;
  final Color? inactiveColor;

  const RoadSafeCombinedProgress({
    super.key,
    required this.steps,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoadSafeStepProgress(
          steps: steps,
          currentStep: currentStep,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
        const SizedBox(height: RoadSafeSpacing.md),
        RoadSafeStepLabels(
          steps: steps,
          currentStep: currentStep,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
      ],
    );
  }
}

class RoadSafeLinearProgress extends StatelessWidget {
  final double progress;
  final Color? color;
  final Color? backgroundColor;
  final double height;

  const RoadSafeLinearProgress({
    super.key,
    required this.progress,
    this.color,
    this.backgroundColor,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? RoadSafeColors.backgroundAlt,
        borderRadius: BorderRadius.circular(RoadSafeRadius.round),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? RoadSafeColors.primary,
            borderRadius: BorderRadius.circular(RoadSafeRadius.round),
          ),
        ),
      ),
    );
  }
}

class RoadSafeCircularProgress extends StatelessWidget {
  final double? progress;
  final Color? color;
  final double strokeWidth;
  final double size;

  const RoadSafeCircularProgress({
    super.key,
    this.progress,
    this.color,
    this.strokeWidth = 3,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? RoadSafeColors.primary),
        backgroundColor: RoadSafeColors.backgroundAlt,
      ),
    );
  }
}
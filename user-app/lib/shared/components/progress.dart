import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

/// Circular progress indicator with modern styling
class AppCircularProgress extends StatelessWidget {
  final double? value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final String? semanticsLabel;
  final String? semanticsValue;

  const AppCircularProgress({
    super.key,
    this.value,
    this.size = 24,
    this.strokeWidth = 3,
    this.color,
    this.backgroundColor,
    this.semanticsLabel,
    this.semanticsValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.progressIndicatorTheme.color ?? AppColors.primary;
    final effectiveBackgroundColor = backgroundColor ?? theme.progressIndicatorTheme.circularTrackColor ?? AppColors.surfaceContainer;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
        backgroundColor: effectiveBackgroundColor,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      ),
    );
  }
}

/// Linear progress indicator
class AppLinearProgress extends StatelessWidget {
  final double? value;
  final double height;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final String? semanticsLabel;
  final String? semanticsValue;

  const AppLinearProgress({
    super.key,
    this.value,
    this.height = 4,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.semanticsLabel,
    this.semanticsValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.progressIndicatorTheme.color ?? AppColors.primary;
    final effectiveBackgroundColor = backgroundColor ?? theme.progressIndicatorTheme.linearTrackColor ?? AppColors.surfaceContainer;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.round),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
        backgroundColor: effectiveBackgroundColor,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      ),
    );
  }
}

/// Step progress indicator (for multi-step flows)
class AppStepProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;
  final Color? activeColor;
  final Color? inactiveColor;
  final double lineWidth;
  final double circleSize;
  final bool showLabels;

  const AppStepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.activeColor,
    this.inactiveColor,
    this.lineWidth = 2,
    this.circleSize = 24,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveInactiveColor = inactiveColor ?? AppColors.outline;

    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        final isLast = index == totalSteps - 1;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  _buildCircle(index, isActive, effectiveActiveColor, effectiveInactiveColor),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: lineWidth,
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: index < currentStep ? effectiveActiveColor : effectiveInactiveColor,
                          borderRadius: BorderRadius.circular(AppRadius.round),
                        ),
                      ),
                    ),
                ],
              ),
              if (showLabels && stepLabels != null && index < stepLabels!.length) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  stepLabels![index],
                  style: AppTypography.labelSmall.copyWith(
                    color: isActive ? effectiveActiveColor : AppColors.textTertiary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCircle(int index, bool isActive, Color activeColor, Color inactiveColor) {
    final isCompleted = index < currentStep;

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? activeColor : AppColors.surface,
        border: Border.all(
          color: isActive ? activeColor : inactiveColor,
          width: 2,
        ),
      ),
      child: isCompleted
          ? Icon(AppIcons.check, size: circleSize * 0.5, color: AppColors.onPrimary)
          : Center(
              child: Text(
                '${index + 1}',
                style: AppTypography.labelSmall.copyWith(
                  color: isActive ? AppColors.onPrimary : inactiveColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}

/// Combined progress indicator (steps + labels) - used in report screen
class AppCombinedProgress extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final Color? activeColor;
  final Color? inactiveColor;

  const AppCombinedProgress({
    super.key,
    required this.steps,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveInactiveColor = inactiveColor ?? AppColors.outline;

    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index <= currentStep;
        final isCompleted = index < currentStep;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  _buildStepCircle(index, isActive, isCompleted, effectiveActiveColor, effectiveInactiveColor),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: isCompleted ? effectiveActiveColor : effectiveInactiveColor,
                          borderRadius: BorderRadius.circular(AppRadius.round),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                steps[index],
                style: AppTypography.labelSmall.copyWith(
                  color: isActive ? effectiveActiveColor : AppColors.textTertiary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepCircle(int index, bool isActive, bool isCompleted, Color activeColor, Color inactiveColor) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? activeColor : AppColors.surface,
        border: Border.all(
          color: isActive ? activeColor : inactiveColor,
          width: 2,
        ),
        boxShadow: isActive ? AppShadows.primaryGlowSubtle : null,
      ),
      child: isCompleted
          ? Icon(AppIcons.check, size: 16, color: AppColors.onPrimary)
          : Center(
              child: Text(
                '${index + 1}',
                style: AppTypography.labelSmall.copyWith(
                  color: isActive ? AppColors.onPrimary : inactiveColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}

/// Skeleton loader for content placeholders
class AppSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBaseColor = baseColor ?? AppColors.surfaceContainer;
    final effectiveHighlightColor = highlightColor ?? AppColors.surfaceContainerHigh;

    return Shimmer(
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: effectiveBaseColor,
          borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}

/// Skeleton loader for list items
class AppSkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;
  final Widget? separator;

  const AppSkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (_, __) => separator ?? const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, __) => AppSkeleton(
        height: itemHeight,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

/// Skeleton loader for card grid
class AppSkeletonGrid extends StatelessWidget {
  final int itemCount;
  final double aspectRatio;
  final int crossAxisCount;
  final double spacing;
  final EdgeInsetsGeometry? padding;

  const AppSkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.aspectRatio = 1.0,
    this.crossAxisCount = 2,
    this.spacing = AppSpacing.md,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => AppSkeleton(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

/// Shimmer effect widget
class Shimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;
  final bool enabled;

  const Shimmer({
    super.key,
    required this.child,
    required this.baseColor,
    required this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Pull to refresh indicator
class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;
  final double displacement;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.displacement = 40,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? AppColors.primary,
      backgroundColor: backgroundColor ?? AppColors.surface,
      displacement: displacement,
      strokeWidth: 3,
      edgeOffset: 0,
      child: child,
    );
  }
}

/// Loading overlay for full-screen loading
class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? overlayColor;

  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: overlayColor ?? AppColors.overlay,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppCircularProgress(size: 48, strokeWidth: 4),
                    if (message != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        message!,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textInverse),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Button loading state
class AppButtonLoading extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final double size;

  const AppButtonLoading({
    super.key,
    required this.isLoading,
    required this.child,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
      ),
    );
  }
}
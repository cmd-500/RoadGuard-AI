import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

enum AppTab { home, map, report, alerts, profile }

class AppBottomNavigation extends StatelessWidget {
  final AppTab currentTab;
  final ValueChanged<AppTab> onTabChanged;
  final bool showFab;
  final Color? backgroundColor;
  final double height;

  const AppBottomNavigation({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
    this.showFab = true,
    this.backgroundColor,
    this.height = 88,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor ?? AppColors.surface;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: const Offset(0, -2),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
        border: Border(top: BorderSide(color: AppColors.outline, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(AppTab.home, AppIcons.home, AppIcons.homeFilled, 'Home'),
              _buildNavItem(AppTab.map, AppIcons.map, AppIcons.mapFilled, 'Map'),
              if (showFab)
                _buildFab(context)
              else
                _buildNavItem(AppTab.report, AppIcons.report, AppIcons.reportFilled, 'Report'),
              _buildNavItem(AppTab.alerts, AppIcons.alerts, AppIcons.alertsFilled, 'Alerts'),
              _buildNavItem(AppTab.profile, AppIcons.profile, AppIcons.profileFilled, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(AppTab tab, IconData regularIcon, IconData filledIcon, String label) {
    final isSelected = currentTab == tab;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTabChanged(tab),
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: AnimatedContainer(
            duration: AppMotion.fadeIn,
            curve: AppMotion.fadeCurve,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: AppMotion.fadeIn,
                  child: Icon(
                    isSelected ? filledIcon : regularIcon,
                    key: ValueKey(isSelected),
                    size: 24,
                    color: isSelected ? AppColors.primary : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: AppMotion.fadeIn,
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textTertiary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  child: Text(label),
                ),
                const SizedBox(height: 2),
                AnimatedContainer(
                  duration: AppMotion.fadeIn,
                  height: 3,
                  width: isSelected ? 20 : 0,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Expanded(
      child: Center(
        child: Transform.translate(
          offset: const Offset(0, -12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTabChanged(AppTab.report),
              borderRadius: BorderRadius.circular(AppRadius.fab),
              child: AnimatedContainer(
                duration: AppMotion.fadeIn,
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.fab),
                  boxShadow: AppShadows.fab,
                ),
                child: Center(
                  child: Icon(
                    AppIcons.plus,
                    size: 30,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppNavigationShell extends StatefulWidget {
  final Widget child;
  final AppTab currentTab;
  final ValueChanged<AppTab> onTabChanged;
  final bool showFab;

  const AppNavigationShell({
    super.key,
    required this.child,
    required this.currentTab,
    required this.onTabChanged,
    this.showFab = true,
  });

  @override
  State<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends State<AppNavigationShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: AppBottomNavigation(
        currentTab: widget.currentTab,
        onTabChanged: widget.onTabChanged,
        showFab: widget.showFab,
      ),
    );
  }
}

class AppFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isExtended;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.isExtended = false,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isExtended) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        tooltip: tooltip,
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: foregroundColor ?? AppColors.onPrimary,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 8,
        highlightElevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.fab),
        ),
        label: label != null ? Text(label!, style: AppTypography.buttonLarge) : const SizedBox.shrink(),
        icon: Icon(icon, size: 24),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
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

class AppSpeedDial extends StatefulWidget {
  final List<AppSpeedDialAction> actions;
  final IconData mainIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;

  const AppSpeedDial({
    super.key,
    required this.actions,
    this.mainIcon = AppIcons.plus,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
  });

  @override
  State<AppSpeedDial> createState() => _AppSpeedDialState();
}

class _AppSpeedDialState extends State<AppSpeedDial> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppMotion.fadeIn,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        //Action buttons
        ...List.generate(widget.actions.length, (index) {
          final action = widget.actions[index];
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  index / widget.actions.length,
                  (index + 1) / widget.actions.length,
                  curve: Curves.easeOutBack,
                ),
              ).value;

              return Transform.translate(
                offset: Offset(0, -progress * (60.0 * (index + 1) + 16.0)),
                child: Opacity(
                  opacity: progress,
                  child: Transform.scale(
                    scale: progress,
                    child: _buildActionButton(action),
                  ),
                ),
              );
            },
          );
        }),
        //Main FAB
        FloatingActionButton(
          onPressed: _toggle,
          tooltip: widget.tooltip,
          backgroundColor: widget.backgroundColor ?? AppColors.primary,
          foregroundColor: widget.foregroundColor ?? AppColors.onPrimary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.fab),
          ),
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0,
            duration: AppMotion.fadeIn,
            child: Icon(widget.mainIcon, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(AppSpeedDialAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _toggle();
          action.onPressed?.call();
        },
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: action.backgroundColor ?? AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.button),
            boxShadow: AppShadows.cardElevated,
            border: Border.all(color: AppColors.outline, width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (action.label != null) ...[
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: Text(
                    action.label!,
                    style: AppTypography.labelMedium.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
              Icon(action.icon, size: 24, color: action.foregroundColor ?? AppColors.textPrimary),
              const SizedBox(width: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class AppSpeedDialAction {
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppSpeedDialAction({
    required this.icon,
    this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });
}
import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

enum RoadSafeTab { home, map, report, alerts, profile }

class RoadSafeBottomNavigation extends StatelessWidget {
  final RoadSafeTab currentTab;
  final ValueChanged<RoadSafeTab> onTabChanged;
  final bool showReportFab;

  const RoadSafeBottomNavigation({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
    this.showReportFab = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RoadSafeColors.surface,
        boxShadow: [
          BoxShadow(
            color: RoadSafeColors.shadow,
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              _buildNavItem(RoadSafeTab.home, RoadSafeIcons.home, RoadSafeIcons.homeFilled, 'Home'),
              _buildNavItem(RoadSafeTab.map, RoadSafeIcons.map, RoadSafeIcons.mapFilled, 'Map'),
              if (showReportFab)
                _buildReportFAB(context)
              else
                _buildNavItem(RoadSafeTab.report, RoadSafeIcons.report, RoadSafeIcons.reportFilled, 'Report'),
              _buildNavItem(RoadSafeTab.alerts, RoadSafeIcons.alerts, RoadSafeIcons.alertsFilled, 'Alerts'),
              _buildNavItem(RoadSafeTab.profile, RoadSafeIcons.profile, RoadSafeIcons.profileFilled, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(RoadSafeTab tab, IconData regularIcon, IconData filledIcon, String label) {
    final isSelected = currentTab == tab;
    final flex = showReportFab && tab == RoadSafeTab.report ? 0 : 1;

    if (flex == 0) return const SizedBox.shrink();

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTabChanged(tab),
          child: Container(
            height: 56,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? filledIcon : regularIcon,
                  size: 24,
                  color: isSelected ? RoadSafeColors.primary : RoadSafeColors.textTertiary,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: RoadSafeTypography.labelSmall.copyWith(
                    color: isSelected ? RoadSafeColors.primary : RoadSafeColors.textTertiary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportFAB(BuildContext context) {
    return Expanded(
      child: Center(
        child: Transform.translate(
          offset: const Offset(0, -8),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: RoadSafeColors.primary,
              borderRadius: BorderRadius.circular(RoadSafeRadius.round),
              boxShadow: RoadSafeShadows.fab,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTabChanged(RoadSafeTab.report),
                borderRadius: BorderRadius.circular(RoadSafeRadius.round),
                child: Center(
                  child: Icon(
                    RoadSafeIcons.plus,
                    size: 28,
                    color: RoadSafeColors.textOnPrimary,
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

class RoadSafeNavigationShell extends StatefulWidget {
  final Widget child;
  final RoadSafeTab currentTab;
  final ValueChanged<RoadSafeTab> onTabChanged;

  const RoadSafeNavigationShell({
    super.key,
    required this.child,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  State<RoadSafeNavigationShell> createState() => _RoadSafeNavigationShellState();
}

class _RoadSafeNavigationShellState extends State<RoadSafeNavigationShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: RoadSafeBottomNavigation(
        currentTab: widget.currentTab,
        onTabChanged: widget.onTabChanged,
      ),
    );
  }
}
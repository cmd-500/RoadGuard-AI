import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

class RoadSafeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onMenuPressed;
  final Color? backgroundColor;
  final double elevation;

  const RoadSafeAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.onMenuPressed,
    this.backgroundColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? RoadSafeColors.surface,
      foregroundColor: RoadSafeColors.textPrimary,
      elevation: elevation,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleSpacing: 0,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: Icon(RoadSafeIcons.back, size: 24),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  padding: const EdgeInsets.only(left: RoadSafeSpacing.screenPadding),
                )
              : (onMenuPressed != null
                  ? IconButton(
                      icon: Icon(RoadSafeIcons.menu, size: 24),
                      onPressed: onMenuPressed,
                      padding: const EdgeInsets.only(left: RoadSafeSpacing.screenPadding),
                    )
                  : null)),
      title: title != null
          ? Text(
              title!,
              style: RoadSafeTypography.headlineSmall,
            )
          : null,
      actions: actions ??
          (onMenuPressed != null
              ? [
                  IconButton(
                    icon: Icon(RoadSafeIcons.menu, size: 24),
                    onPressed: onMenuPressed,
                    padding: const EdgeInsets.only(right: RoadSafeSpacing.screenPadding),
                  ),
                ]
              : null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class RoadSafeSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onLocationPressed;
  final TextEditingController? controller;
  final Color? backgroundColor;

  const RoadSafeSearchAppBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.onFilterPressed,
    this.onLocationPressed,
    this.controller,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? RoadSafeColors.surface,
      foregroundColor: RoadSafeColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.screenPadding),
        decoration: BoxDecoration(
          color: RoadSafeColors.background,
          borderRadius: BorderRadius.circular(RoadSafeRadius.round),
          border: Border.all(color: RoadSafeColors.border),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textTertiary),
            prefixIcon: Icon(RoadSafeIcons.search, size: 20, color: RoadSafeColors.textTertiary),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onLocationPressed != null)
                  IconButton(
                    icon: Icon(RoadSafeIcons.location, size: 20, color: RoadSafeColors.textSecondary),
                    onPressed: onLocationPressed,
                    padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.sm),
                  ),
                if (onFilterPressed != null)
                  IconButton(
                    icon: Icon(RoadSafeIcons.filter, size: 20, color: RoadSafeColors.textSecondary),
                    onPressed: onFilterPressed,
                    padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.sm),
                  ),
              ],
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: RoadSafeSpacing.md),
          ),
          style: RoadSafeTypography.bodyMedium,
        ),
      ),
      toolbarHeight: 72,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class RoadSafeSimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;

  const RoadSafeSimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? RoadSafeColors.surface,
      foregroundColor: RoadSafeColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleSpacing: 0,
      leading: leading,
      title: Text(title, style: RoadSafeTypography.headlineSmall),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
import 'package:flutter/material.dart';
import '../../core/design_system/index.dart';
import 'icons.dart';

/// Standard app bar with title and actions
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final double scrolledUnderElevation;
  final bool centerTitle;
  final TextStyle? titleTextStyle;
  final double? toolbarHeight;

  const AppAppBar({
    super.key,
    this.title,
    this.leading,
    this.showBackButton = false,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.scrolledUnderElevation = 0,
    this.centerTitle = false,
    this.titleTextStyle,
    this.toolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ?? theme.appBarTheme.backgroundColor ?? AppColors.surface;
    final effectiveFgColor = foregroundColor ?? theme.appBarTheme.foregroundColor ?? AppColors.textPrimary;

    return AppBar(
      title: title != null ? Text(title!, style: titleTextStyle ?? theme.appBarTheme.titleTextStyle) : null,
      leading: leading ?? (showBackButton ? _buildBackButton(context, effectiveFgColor) : null),
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      backgroundColor: effectiveBgColor,
      foregroundColor: effectiveFgColor,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      titleTextStyle: titleTextStyle ?? theme.appBarTheme.titleTextStyle,
      toolbarHeight: toolbarHeight ?? theme.appBarTheme.toolbarHeight,
      automaticallyImplyLeading: false,
    );
  }

  Widget? _buildBackButton(BuildContext context, Color color) {
    return IconButton(
      icon: Icon(AppIcons.back, size: 22, color: color),
      onPressed: () => Navigator.of(context).maybePop(),
      padding: const EdgeInsets.only(left: AppSpacing.screenPadding),
      tooltip: 'Back',
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? AppSpacing.appBarHeight);
}

/// Search app bar with built-in search field
class AppSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onLocationPressed;
  final VoidCallback? onSearchPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double elevation;

  const AppSearchAppBar({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onFilterPressed,
    this.onLocationPressed,
    this.onSearchPressed,
    this.actions,
    this.backgroundColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ?? theme.appBarTheme.backgroundColor ?? AppColors.surface;

    return AppBar(
      backgroundColor: effectiveBgColor,
      elevation: elevation,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: AppSpacing.appBarHeight + 12,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.sm),
        child: _buildSearchField(context),
      ),
      actions: actions ??
          [
            if (onFilterPressed != null)
              IconButton(
                icon: Icon(AppIcons.filter, size: 22, color: theme.iconTheme.color),
                onPressed: onFilterPressed,
                tooltip: 'Filter',
              ),
            if (onLocationPressed != null)
              IconButton(
                icon: Icon(AppIcons.myLocation, size: 22, color: theme.iconTheme.color),
                onPressed: onLocationPressed,
                tooltip: 'Current Location',
              ),
          ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onSearchPressed,
        readOnly: onSearchPressed != null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
          prefixIcon: Icon(AppIcons.search, size: 20, color: AppColors.textTertiary),
          filled: true,
          fillColor: AppColors.surfaceContainerLow,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: AppBorders.inputFocus,
          ),
        ),
        style: AppTypography.bodyMedium,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.appBarHeight + 12);
}

/// Sliver app bar for scrollable content
class AppSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final bool floating;
  final bool pinned;
  final bool snap;
  final double expandedHeight;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;

  const AppSliverAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.flexibleSpace,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.expandedHeight = 200,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ?? theme.appBarTheme.backgroundColor ?? AppColors.surface;
    final effectiveFgColor = foregroundColor ?? theme.appBarTheme.foregroundColor ?? AppColors.textPrimary;

    return SliverAppBar(
      title: title != null ? Text(title!, style: theme.appBarTheme.titleTextStyle) : null,
      leading: leading,
      actions: actions,
      flexibleSpace: flexibleSpace,
      floating: floating,
      pinned: pinned,
      snap: snap,
      expandedHeight: expandedHeight,
      backgroundColor: effectiveBgColor,
      foregroundColor: effectiveFgColor,
      elevation: elevation,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: theme.appBarTheme.titleTextStyle,
      toolbarHeight: theme.appBarTheme.toolbarHeight ?? AppSpacing.appBarHeight,
      automaticallyImplyLeading: false,
    );
  }
}

/// Bottom app bar for bottom navigation integration
class AppBottomAppBar extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double elevation;
  final double height;

  const AppBottomAppBar({
    super.key,
    this.child,
    this.color,
    this.elevation = 8,
    this.height = AppSpacing.bottomNavHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.bottomNavigationBarTheme.backgroundColor ?? AppColors.surface;

    return BottomAppBar(
      color: effectiveColor,
      elevation: elevation,
      height: height,
      child: child ?? const SizedBox.shrink(),
    );
  }
}

/// Custom app bar with gradient background
class AppGradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Gradient gradient;
  final double elevation;
  final bool centerTitle;
  final TextStyle? titleTextStyle;
  final double toolbarHeight;

  const AppGradientAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    required this.gradient,
    this.elevation = 0,
    this.centerTitle = false,
    this.titleTextStyle,
    this.toolbarHeight = AppSpacing.appBarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PreferredSize(
      preferredSize: Size.fromHeight(toolbarHeight),
      child: Container(
        height: toolbarHeight,
        decoration: BoxDecoration(
          gradient: gradient,
          boxShadow: elevation > 0
              ? [
                  BoxShadow(
                    color: AppColors.shadow,
                    offset: Offset(0, elevation / 4),
                    blurRadius: elevation,
                  ),
                ]
              : null,
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppSpacing.sm),
                ],
                if (title != null)
                  Text(
                    title!,
                    style: titleTextStyle ?? theme.appBarTheme.titleTextStyle?.copyWith(color: AppColors.onPrimary),
                  ),
                const Spacer(),
                if (actions != null) ...actions!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}

/// Tab bar app bar
class AppTabBarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final List<Widget> tabs;
  final TabController? controller;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double elevation;

  const AppTabBarAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    required this.tabs,
    this.controller,
    this.backgroundColor,
    this.indicatorColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ?? theme.appBarTheme.backgroundColor ?? AppColors.surface;

    return AppBar(
      title: title != null ? Text(title!, style: theme.appBarTheme.titleTextStyle) : null,
      leading: leading,
      actions: actions,
      backgroundColor: effectiveBgColor,
      elevation: elevation,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: theme.appBarTheme.titleTextStyle,
      toolbarHeight: theme.appBarTheme.toolbarHeight,
      automaticallyImplyLeading: false,
      bottom: TabBar(
        tabs: tabs,
        controller: controller,
        indicatorColor: indicatorColor ?? AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        labelStyle: AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelLarge,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.primaryContainer;
          }
          return Colors.transparent;
        }),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.appBarHeight + 12);
}
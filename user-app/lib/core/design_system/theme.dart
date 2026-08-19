import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          secondaryContainer: AppColors.secondaryContainer,
          onSecondaryContainer: AppColors.onSecondaryContainer,
          tertiary: AppColors.tertiary,
          onTertiary: AppColors.onTertiary,
          tertiaryContainer: AppColors.tertiaryContainer,
          onTertiaryContainer: AppColors.onTertiaryContainer,
          error: AppColors.error,
          onError: AppColors.onError,
          errorContainer: AppColors.errorLight,
          onErrorContainer: AppColors.error,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          surfaceContainerHighest: AppColors.surfaceContainerHighest,
          onSurfaceVariant: AppColors.textSecondary,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
          shadow: AppColors.shadow,
          scrim: AppColors.scrim,
          inverseSurface: AppColors.inverseSurface,
          onInverseSurface: AppColors.surface,
          inversePrimary: AppColors.primaryLight,
        ),
        fontFamily: AppTypography.fontFamily,
        textTheme: const TextTheme(
          displayLarge: AppTypography.displayLarge,
          displayMedium: AppTypography.displayMedium,
          displaySmall: AppTypography.displaySmall,
          headlineLarge: AppTypography.headlineLarge,
          headlineMedium: AppTypography.headlineMedium,
          headlineSmall: AppTypography.headlineSmall,
          titleLarge: AppTypography.titleLarge,
          titleMedium: AppTypography.titleMedium,
          titleSmall: AppTypography.titleSmall,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
          labelMedium: AppTypography.labelMedium,
          labelSmall: AppTypography.labelSmall,
        ).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.headlineSmall,
          toolbarHeight: AppSpacing.appBarHeight,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            textStyle: AppTypography.buttonLarge,
            elevation: 0,
            shadowColor: Colors.transparent,
            minimumSize: const Size(88, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            textStyle: AppTypography.buttonLarge,
            minimumSize: const Size(88, 48),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            textStyle: AppTypography.buttonLarge,
            minimumSize: const Size(88, 48),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            textStyle: AppTypography.labelLarge,
            minimumSize: const Size(48, 40),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.buttonSmall),
            ),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.all(AppSpacing.sm),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: AppBorders.input,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: AppBorders.input,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: AppBorders.inputFocus,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: AppBorders.inputError,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: AppBorders.inputError.copyWith(width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: AppBorders.hairline,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
          labelStyle: AppTypography.titleSmall.copyWith(color: AppColors.textSecondary),
          floatingLabelStyle: AppTypography.titleSmall.copyWith(color: AppColors.primary),
          errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
          helperStyle: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
          counterStyle: AppTypography.caption.copyWith(color: AppColors.textTertiary),
          prefixIconColor: AppColors.textTertiary,
          suffixIconColor: AppColors.textTertiary,
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: AppBorders.card,
          ),
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppTypography.labelSmall,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primaryContainer,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              );
            }
            return AppTypography.labelSmall.copyWith(color: AppColors.textTertiary);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: AppColors.primary, size: 24);
            }
            return IconThemeData(color: AppColors.textTertiary, size: 24);
          }),
          height: 72,
          elevation: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceContainerLow,
          disabledColor: AppColors.surfaceContainer,
          selectedColor: AppColors.primaryContainer,
          secondarySelectedColor: AppColors.primaryContainer,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          labelStyle: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
          secondaryLabelStyle: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          brightness: Brightness.light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.chip),
            side: AppBorders.chip,
          ),
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
          indent: 0,
          endIndent: 0,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textSecondary,
          size: 24,
        ),
        primaryIconTheme: const IconThemeData(
          color: AppColors.onPrimary,
          size: 24,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.primary,
          linearTrackColor: AppColors.surfaceContainer,
          circularTrackColor: AppColors.surfaceContainer,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.outline,
          thumbColor: AppColors.primary,
          overlayColor: AppColors.primaryContainer,
          valueIndicatorColor: AppColors.primary,
          valueIndicatorTextStyle: AppTypography.labelSmall.copyWith(color: AppColors.onPrimary),
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          labelStyle: AppTypography.labelLarge,
          unselectedLabelStyle: AppTypography.labelLarge,
          indicator: UnderlineTabIndicator(
            borderSide: const BorderSide(color: AppColors.primary, width: 3),
            insets: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          ),
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return AppColors.primaryContainer;
            }
            return Colors.transparent;
          }),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.surface),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 4,
          actionTextColor: AppColors.primaryLight,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surface,
          elevation: 8,
          shadowColor: AppColors.shadowStrong,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.modal),
          ),
          titleTextStyle: AppTypography.headlineSmall,
          contentTextStyle: AppTypography.bodyMedium,
          actionsPadding: const EdgeInsets.all(AppSpacing.md),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.surface,
          elevation: 8,
          shadowColor: AppColors.shadowStrong,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
          ),
          showDragHandle: true,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: AppColors.surface,
          elevation: 8,
          shadowColor: AppColors.shadowStrong,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          textStyle: AppTypography.bodyMedium,
          labelTextStyle: WidgetStateProperty.all(AppTypography.bodyMedium),
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(AppRadius.tooltip),
          ),
          textStyle: AppTypography.labelSmall.copyWith(color: AppColors.surface),
          preferBelow: true,
          verticalOffset: 8,
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: AppColors.surface,
          hourMinuteShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          dayPeriodShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          dialHandColor: AppColors.primary,
          dialBackgroundColor: AppColors.primaryContainer,
          entryModeIconColor: AppColors.primary,
          hourMinuteTextColor: AppColors.textPrimary,
          dayPeriodTextColor: AppColors.textPrimary,
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: AppColors.surface,
          headerBackgroundColor: AppColors.primary,
          headerForegroundColor: AppColors.onPrimary,
          headerHeadlineStyle: AppTypography.titleLarge.copyWith(color: AppColors.onPrimary),
          weekdayStyle: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
          dayStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
          todayBackgroundColor: WidgetStateProperty.all(AppColors.primaryContainer),
          todayForegroundColor: WidgetStateProperty.all(AppColors.primaryDark),
          rangePickerHeaderBackgroundColor: AppColors.primary,
          rangePickerHeaderForegroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.modal),
          ),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return AppColors.primaryContainer;
              return AppColors.surface;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return AppColors.primary;
              return AppColors.textSecondary;
            }),
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return BorderSide.none;
              return AppBorders.thin;
            }),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          titleTextStyle: AppTypography.titleMedium,
          subtitleTextStyle: AppTypography.bodySmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          tileColor: Colors.transparent,
          selectedTileColor: AppColors.primaryContainer,
          selectedColor: AppColors.primary,
          iconColor: AppColors.textSecondary,
          textColor: AppColors.textPrimary,
        ),
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: AppColors.surface,
          collapsedBackgroundColor: AppColors.surface,
          textColor: AppColors.textPrimary,
          collapsedTextColor: AppColors.textPrimary,
          iconColor: AppColors.textSecondary,
          collapsedIconColor: AppColors.textTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: AppBorders.thin,
          ),
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColorsDark.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColorsDark.primary,
          onPrimary: AppColorsDark.onPrimary,
          primaryContainer: AppColorsDark.primaryContainer,
          onPrimaryContainer: AppColorsDark.onPrimaryContainer,
          secondary: AppColorsDark.secondary,
          onSecondary: AppColorsDark.onSecondary,
          secondaryContainer: AppColorsDark.secondaryContainer,
          onSecondaryContainer: AppColorsDark.onSecondaryContainer,
          tertiary: AppColorsDark.tertiary,
          onTertiary: AppColorsDark.onTertiary,
          tertiaryContainer: AppColorsDark.tertiaryContainer,
          onTertiaryContainer: AppColorsDark.onTertiaryContainer,
          error: AppColorsDark.error,
          onError: AppColorsDark.onError,
          errorContainer: AppColorsDark.errorLight,
          onErrorContainer: AppColorsDark.errorLight,
          surface: AppColorsDark.surface,
          onSurface: AppColorsDark.textPrimary,
          outline: AppColorsDark.outline,
          outlineVariant: AppColorsDark.outlineVariant,
          shadow: AppColorsDark.shadow,
          scrim: AppColorsDark.scrim,
          inverseSurface: AppColorsDark.inverseSurface,
          onInverseSurface: AppColorsDark.surface,
          inversePrimary: AppColorsDark.primaryLight,
        ),
        fontFamily: AppTypography.fontFamily,
        textTheme: const TextTheme(
          displayLarge: AppTypographyDark.displayLarge,
          displayMedium: AppTypographyDark.displayMedium,
          displaySmall: AppTypographyDark.displaySmall,
          headlineLarge: AppTypographyDark.headlineLarge,
          headlineMedium: AppTypographyDark.headlineMedium,
          headlineSmall: AppTypographyDark.headlineSmall,
          titleLarge: AppTypographyDark.titleLarge,
          titleMedium: AppTypographyDark.titleMedium,
          titleSmall: AppTypographyDark.titleSmall,
          bodyLarge: AppTypographyDark.bodyLarge,
          bodyMedium: AppTypographyDark.bodyMedium,
          bodySmall: AppTypographyDark.bodySmall,
          labelLarge: AppTypographyDark.labelLarge,
          labelMedium: AppTypographyDark.labelMedium,
          labelSmall: AppTypographyDark.labelSmall,
        ).apply(
          bodyColor: AppColorsDark.textPrimary,
          displayColor: AppColorsDark.textPrimary,
        ),
        // Without this, dark mode fell back to Flutter's default
        // InputDecorationTheme, which doesn't match AppColorsDark and was
        // part of why typed text could become unreadable in dark mode.
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColorsDark.surfaceContainerLow,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: BorderSide(color: AppColorsDark.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: BorderSide(color: AppColorsDark.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: BorderSide(color: AppColorsDark.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: BorderSide(color: AppColorsDark.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: BorderSide(color: AppColorsDark.error, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: BorderSide(color: AppColorsDark.outlineVariant),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          hintStyle: AppTypographyDark.bodyMedium.copyWith(color: AppColorsDark.textTertiary),
          labelStyle: AppTypographyDark.titleSmall.copyWith(color: AppColorsDark.textSecondary),
          floatingLabelStyle: AppTypographyDark.titleSmall.copyWith(color: AppColorsDark.primary),
          errorStyle: AppTypographyDark.bodySmall.copyWith(color: AppColorsDark.error),
          helperStyle: AppTypographyDark.bodySmall.copyWith(color: AppColorsDark.textTertiary),
          prefixIconColor: AppColorsDark.textTertiary,
          suffixIconColor: AppColorsDark.textTertiary,
        ),
      );
}
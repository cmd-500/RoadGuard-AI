import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

class RoadSafeTheme {
  RoadSafeTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: RoadSafeColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RoadSafeColors.primary,
          primary: RoadSafeColors.primary,
          secondary: RoadSafeColors.secondary,
          surface: RoadSafeColors.surface,
          error: RoadSafeColors.error,
          onPrimary: RoadSafeColors.textOnPrimary,
          onSurface: RoadSafeColors.textOnSurface,
          onError: RoadSafeColors.textOnPrimary,
        ),
        fontFamily: RoadSafeTypography.fontFamily,
        textTheme: TextTheme(
          displayLarge: RoadSafeTypography.displayLarge,
          displayMedium: RoadSafeTypography.displayMedium,
          displaySmall: RoadSafeTypography.displaySmall,
          headlineLarge: RoadSafeTypography.headlineLarge,
          headlineMedium: RoadSafeTypography.headlineMedium,
          headlineSmall: RoadSafeTypography.headlineSmall,
          titleLarge: RoadSafeTypography.titleLarge,
          titleMedium: RoadSafeTypography.titleMedium,
          titleSmall: RoadSafeTypography.titleSmall,
          bodyLarge: RoadSafeTypography.bodyLarge,
          bodyMedium: RoadSafeTypography.bodyMedium,
          bodySmall: RoadSafeTypography.bodySmall,
          labelLarge: RoadSafeTypography.labelLarge,
          labelMedium: RoadSafeTypography.labelMedium,
          labelSmall: RoadSafeTypography.labelSmall,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: RoadSafeColors.surface,
          foregroundColor: RoadSafeColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          titleTextStyle: RoadSafeTypography.headlineSmall,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: RoadSafeColors.primary,
            foregroundColor: RoadSafeColors.textOnPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: RoadSafeSpacing.xl,
              vertical: RoadSafeSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
            ),
            textStyle: RoadSafeTypography.buttonLarge,
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: RoadSafeColors.primary,
            side: BorderSide(color: RoadSafeColors.primary, width: 1.5),
            padding: const EdgeInsets.symmetric(
              horizontal: RoadSafeSpacing.xl,
              vertical: RoadSafeSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
            ),
            textStyle: RoadSafeTypography.buttonLarge,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: RoadSafeColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: RoadSafeSpacing.md,
              vertical: RoadSafeSpacing.sm,
            ),
            textStyle: RoadSafeTypography.labelLarge,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: RoadSafeColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
            borderSide: BorderSide(color: RoadSafeColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
            borderSide: BorderSide(color: RoadSafeColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
            borderSide: BorderSide(color: RoadSafeColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
            borderSide: BorderSide(color: RoadSafeColors.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
            borderSide: BorderSide(color: RoadSafeColors.error, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: RoadSafeSpacing.lg,
            vertical: RoadSafeSpacing.md,
          ),
          hintStyle: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textTertiary),
          labelStyle: RoadSafeTypography.titleSmall,
          errorStyle: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.error),
        ),
        cardTheme: CardThemeData(
          color: RoadSafeColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.xl),
            side: BorderSide(color: RoadSafeColors.border),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: RoadSafeColors.surface,
          selectedItemColor: RoadSafeColors.primary,
          unselectedItemColor: RoadSafeColors.textTertiary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: RoadSafeTypography.labelSmall.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: RoadSafeTypography.labelSmall,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: RoadSafeColors.background,
          selectedColor: RoadSafeColors.primaryContainer,
          labelStyle: RoadSafeTypography.labelMedium.copyWith(color: RoadSafeColors.textSecondary),
          secondaryLabelStyle: RoadSafeTypography.labelMedium.copyWith(color: RoadSafeColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.round),
            side: BorderSide(color: RoadSafeColors.border),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: RoadSafeSpacing.md,
            vertical: RoadSafeSpacing.xs,
          ),
        ),
        dividerTheme: DividerThemeData(
          color: RoadSafeColors.divider,
          thickness: 1,
          space: 1,
        ),
        iconTheme: IconThemeData(
          color: RoadSafeColors.textSecondary,
          size: 24,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: RoadSafeColors.primary,
          linearTrackColor: RoadSafeColors.backgroundAlt,
          circularTrackColor: RoadSafeColors.backgroundAlt,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: RoadSafeColors.textPrimary,
          contentTextStyle: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.surface),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: RoadSafeColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.xl),
          ),
          titleTextStyle: RoadSafeTypography.headlineSmall,
          contentTextStyle: RoadSafeTypography.bodyMedium,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: RoadSafeColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(RoadSafeRadius.xxl)),
          ),
          elevation: 8,
        ),
      );

  static ThemeData get dark => light.copyWith(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: RoadSafeColors.primary,
          primary: RoadSafeColors.primary,
          secondary: RoadSafeColors.secondary,
          surface: const Color(0xFF1E1E1E),
          error: RoadSafeColors.error,
          onPrimary: RoadSafeColors.textOnPrimary,
          onSurface: RoadSafeColors.surface,
          onError: RoadSafeColors.textOnPrimary,
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RoadSafeRadius.xl),
            side: BorderSide(color: const Color(0xFF333333)),
          ),
        ),
      );
}
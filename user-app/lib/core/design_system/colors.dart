import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand - Deep Teal/Emerald (trust, safety, road)
  static const Color primary = Color(0xFF00875F);
  static const Color primaryLight = Color(0xFF34D399);
  static const Color primaryDark = Color(0xFF005A3D);
  static const Color primaryContainer = Color(0xFFD1FAE5);
  static const Color primaryContainerDark = Color(0xFF064E3B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF002010);

  // Secondary - Deep Navy (authority, night driving)
  static const Color secondary = Color(0xFF0F172A);
  static const Color secondaryLight = Color(0xFF3B82F6);
  static const Color secondaryContainer = Color(0xFFDBEAFE);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF1E3A5F);

  // Tertiary - Warm Amber (caution, attention)
  static const Color tertiary = Color(0xFFF59E0B);
  static const Color tertiaryLight = Color(0xFFFBBF24);
  static const Color tertiaryContainer = Color(0xFFFEF3C7);
  static const Color onTertiary = Color(0xFF000000);
  static const Color onTertiaryContainer = Color(0xFF78350F);

  // Semantic - Success
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF064E3B);
  static const Color onSuccess = Color(0xFFFFFFFF);

  // Semantic - Warning
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFF78350F);
  static const Color onWarning = Color(0xFF000000);

  // Semantic - Error
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFF991B1B);
  static const Color onError = Color(0xFFFFFFFF);

  // Semantic - Info
  static const Color info = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF1E3A5F);
  static const Color onInfo = Color(0xFFFFFFFF);

  // Surface - Light Theme (clean, layered)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFF8FAFC);
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F5F9);
  static const Color surfaceContainer = Color(0xFFE2E8F0);
  static const Color surfaceContainerHigh = Color(0xFFCBD5E1);
  static const Color surfaceContainerHighest = Color(0xFF94A3B8);
  static const Color inverseSurface = Color(0xFF0F172A);

  // Background
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundAlt = Color(0xFFF0F4F8);
  static const Color onBackground = Color(0xFF0F172A);

  // Text - Light Theme
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Outline & Divider
  static const Color outline = Color(0xFFE2E8F0);
  static const Color outlineStrong = Color(0xFFCBD5E1);
  static const Color outlineVariant = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFE2E8F0);

  // Shadow & Overlay
  static const Color shadow = Color(0x1A000000);
  static const Color shadowMedium = Color(0x26000000);
  static const Color shadowStrong = Color(0x33000000);
  static const Color overlay = Color(0x80000000);
  static const Color overlayStrong = Color(0xCC000000);
  static const Color scrim = Color(0x80000000);

  // Gradients - Brand
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientAlt = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientSubtle = LinearGradient(
    colors: [primaryContainer, primaryContainerDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradients - Surface
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surface, surfaceDim],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, backgroundAlt],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Gradients - Glassmorphism
  static const LinearGradient glassLight = LinearGradient(
    colors: [Color(0x80FFFFFF), Color(0x40FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassDark = LinearGradient(
    colors: [Color(0x40000000), Color(0x20000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradients - Status
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, successDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warning, warningDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, errorDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Hazard Colors (semantic, accessible)
  static const Map<String, Color> hazardColors = {
    'POTHOLE': Color(0xFFEA580C),
    'ACCIDENT': Color(0xFFDC2626),
    'FOG': Color(0xFF2563EB),
    'SPEED_BREAKER': Color(0xFFD97706),
    'UNMARKED_BREAKER': Color(0xFFD97706),
    'ILLEGAL_BREAKER': Color(0xFFD97706),
    'WATERLOGGING': Color(0xFF0891B2),
    'WATERLOGGED_HAZARD': Color(0xFF0891B2),
    'ROAD_DAMAGE': Color(0xFFEA580C),
    'CONSTRUCTION': Color(0xFF7C3AED),
    'EMERGENCY': Color(0xFFDC2626),
    'OTHER': Color(0xFF64748B),
  };

  static const Map<String, Color> hazardLightColors = {
    'POTHOLE': Color(0xFFFFEDD5),
    'ACCIDENT': Color(0xFFFEE2E2),
    'FOG': Color(0xFFDBEAFE),
    'SPEED_BREAKER': Color(0xFFFEF3C7),
    'UNMARKED_BREAKER': Color(0xFFFEF3C7),
    'ILLEGAL_BREAKER': Color(0xFFFEF3C7),
    'WATERLOGGING': Color(0xFFCFFAFE),
    'WATERLOGGED_HAZARD': Color(0xFFCFFAFE),
    'ROAD_DAMAGE': Color(0xFFFFEDD5),
    'CONSTRUCTION': Color(0xFFEDE9FE),
    'EMERGENCY': Color(0xFFFEE2E2),
    'OTHER': Color(0xFFF1F5F9),
  };

  // Severity Colors
  static const Map<String, Color> severityColors = {
    'CRITICAL': Color(0xFFDC2626),
    'HIGH': Color(0xFFEA580C),
    'MEDIUM': Color(0xFFD97706),
    'LOW': Color(0xFF059669),
    'INFO': Color(0xFF2563EB),
    'INFORMATIONAL': Color(0xFF2563EB),
  };

  static const Map<String, Color> severityLightColors = {
    'CRITICAL': Color(0xFFFEE2E2),
    'HIGH': Color(0xFFFFEDD5),
    'MEDIUM': Color(0xFFFEF3C7),
    'LOW': Color(0xFFD1FAE5),
    'INFO': Color(0xFFDBEAFE),
    'INFORMATIONAL': Color(0xFFDBEAFE),
  };

  static Color hazardColor(String hazardType) {
    return hazardColors[hazardType.toUpperCase()] ?? primary;
  }

  static Color hazardLightColor(String hazardType) {
    return hazardLightColors[hazardType.toUpperCase()] ?? primaryContainer;
  }

  static Color severityColor(String severity) {
    return severityColors[severity.toUpperCase()] ?? info;
  }

  static Color severityLightColor(String severity) {
    return severityLightColors[severity.toUpperCase()] ?? infoLight;
  }

  // Status Colors
  static const Map<String, Color> statusColors = {
    'OPEN': info,
    'IN_PROGRESS': warning,
    'RESOLVED': success,
    'CLOSED': textTertiary,
    'REJECTED': error,
    'PENDING': info,
  };

  static const Map<String, Color> statusLightColors = {
    'OPEN': infoLight,
    'IN_PROGRESS': warningLight,
    'RESOLVED': successLight,
    'CLOSED': Color(0xFFF1F5F9),
    'REJECTED': errorLight,
    'PENDING': infoLight,
  };

  static Color statusColor(String status) {
    return statusColors[status.toUpperCase()] ?? textSecondary;
  }

  static Color statusLightColor(String status) {
    return statusLightColors[status.toUpperCase()] ?? surfaceContainer;
  }
}

// Dark Theme Colors
class AppColorsDark {
  AppColorsDark._();

  // Brand
  static const Color primary = Color(0xFF34D399);
  static const Color primaryLight = Color(0xFF6EE7B7);
  static const Color primaryDark = Color(0xFF10B981);
  static const Color primaryContainer = Color(0xFF064E3B);
  static const Color primaryContainerDark = Color(0xFF022C22);
  static const Color onPrimary = Color(0xFF002010);
  static const Color onPrimaryContainer = Color(0xFFD1FAE5);

  // Secondary
  static const Color secondary = Color(0xFF60A5FA);
  static const Color secondaryLight = Color(0xFF93C5FD);
  static const Color secondaryContainer = Color(0xFF1E3A5F);
  static const Color onSecondary = Color(0xFF1E3A5F);
  static const Color onSecondaryContainer = Color(0xFFDBEAFE);

  // Tertiary
  static const Color tertiary = Color(0xFFFBBF24);
  static const Color tertiaryLight = Color(0xFFFDE047);
  static const Color tertiaryContainer = Color(0xFF78350F);
  static const Color onTertiary = Color(0xFF422006);
  static const Color onTertiaryContainer = Color(0xFFFEF3C7);

  // Semantic
  static const Color success = Color(0xFF34D399);
  static const Color successLight = Color(0xFF064E3B);
  static const Color warning = Color(0xFFFBBF24);
  static const Color warningLight = Color(0xFF78350F);
  static const Color error = Color(0xFFF87171);
  static const Color errorLight = Color(0xFF7F1D1D);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color info = Color(0xFF60A5FA);
  static const Color infoLight = Color(0xFF1E3A5F);

  // Surface - Dark Theme
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceDim = Color(0xFF0F172A);
  static const Color surfaceBright = Color(0xFF334155);
  static const Color surfaceContainerLowest = Color(0xFF0F172A);
  static const Color surfaceContainerLow = Color(0xFF1E293B);
  static const Color surfaceContainer = Color(0xFF334155);
  static const Color surfaceContainerHigh = Color(0xFF475569);
  static const Color surfaceContainerHighest = Color(0xFF64748B);
  static const Color inverseSurface = Color(0xFFFAFAFA);

  // Background
  static const Color background = Color(0xFF020617);
  static const Color backgroundAlt = Color(0xFF0F172A);
  static const Color onBackground = Color(0xFFF8FAFC);

  // Text - Dark Theme
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF475569);
  static const Color textInverse = Color(0xFF0F172A);

  // Outline & Divider
  static const Color outline = Color(0xFF334155);
  static const Color outlineStrong = Color(0xFF475569);
  static const Color outlineVariant = Color(0xFF1E293B);
  static const Color divider = Color(0xFF334155);

  // Shadow & Overlay
  static const Color shadow = Color(0x33000000);
  static const Color shadowMedium = Color(0x40000000);
  static const Color shadowStrong = Color(0x50000000);
  static const Color overlay = Color(0x80000000);
  static const Color overlayStrong = Color(0xCC000000);
  static const Color scrim = Color(0x80000000);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surface, surfaceDim],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassLight = LinearGradient(
    colors: [Color(0x40FFFFFF), Color(0x20FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassDark = LinearGradient(
    colors: [Color(0x20000000), Color(0x10000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
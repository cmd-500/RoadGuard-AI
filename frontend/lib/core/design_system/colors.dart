import 'package:flutter/material.dart';

class RoadSafeColors {
  RoadSafeColors._();

  static const Color primary = Color(0xFF1F5F4A);
  static const Color primaryLight = Color(0xFF2E7D5E);
  static const Color primaryDark = Color(0xFF14402F);
  static const Color primaryContainer = Color(0xFFE8F5EE);

  static const Color secondary = Color(0xFF1E3A5F);
  static const Color secondaryLight = Color(0xFF2D5A8E);
  static const Color secondaryContainer = Color(0xFFE8F0FA);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F7F5);
  static const Color backgroundAlt = Color(0xFFF0F0ED);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSurface = Color(0xFF1A1A1A);

  static const Color border = Color(0xFFE2E2E0);
  static const Color borderStrong = Color(0xFFD0D0CC);
  static const Color divider = Color(0xFFE8E8E5);

  static const Color critical = Color(0xFFC0392B);
  static const Color criticalLight = Color(0xFFFDECEA);
  static const Color high = Color(0xFFE07A2C);
  static const Color highLight = Color(0xFFFEF0E8);
  static const Color medium = Color(0xFFD4A72C);
  static const Color mediumLight = Color(0xFFFEF9E8);
  static const Color low = Color(0xFF4A8C6D);
  static const Color lowLight = Color(0xFFE8F5EE);
  static const Color informational = Color(0xFF2D5A8E);
  static const Color informationalLight = Color(0xFFE8F0FA);

  static const Color success = Color(0xFF27AE60);
  static const Color successLight = Color(0xFFE8F8EE);
  static const Color warning = Color(0xFFF2994A);
  static const Color warningLight = Color(0xFFFEF5E8);
  static const Color error = Color(0xFFEB5757);
  static const Color errorLight = Color(0xFFFDEDEA);

  static const Color overlay = Color(0x80000000);
  static const Color shadow = Color(0x1A000000);
  static const Color shadowStrong = Color(0x33000000);

  static Color severityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
        return critical;
      case 'HIGH':
        return high;
      case 'MEDIUM':
        return medium;
      case 'LOW':
        return low;
      default:
        return informational;
    }
  }

  static Color severityBackground(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
        return criticalLight;
      case 'HIGH':
        return highLight;
      case 'MEDIUM':
        return mediumLight;
      case 'LOW':
        return lowLight;
      default:
        return informationalLight;
    }
  }

  static Color hazardColor(String hazardType) {
    switch (hazardType.toUpperCase()) {
      case 'POTHOLE':
        return high;
      case 'ACCIDENT':
        return critical;
      case 'FOG':
        return informational;
      case 'SPEED_BREAKER':
      case 'UNMARKED_BREAKER':
      case 'ILLEGAL_BREAKER':
        return medium;
      case 'WATERLOGGING':
      case 'WATERLOGGED_HAZARD':
        return secondary;
      case 'ROAD_DAMAGE':
        return high;
      case 'CONSTRUCTION':
        return warning;
      case 'EMERGENCY':
        return critical;
      default:
        return primary;
    }
  }
}
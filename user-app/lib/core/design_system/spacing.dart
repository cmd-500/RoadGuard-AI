import 'package:flutter/material.dart';
import 'colors.dart';

class AppSpacing {
  AppSpacing._();

  // Base spacing scale (4px base) - refined for modern UI
  static const double space0 = 0.0;
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space7 = 28.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  static const double space16 = 64.0;
  static const double space20 = 80.0;
  static const double space24 = 96.0;

  // Semantic aliases for readability
  static const double xs = space1;      // 4
  static const double sm = space2;      // 8
  static const double md = space3;      // 12
  static const double lg = space4;      // 16
  static const double xl = space5;      // 20
  static const double xxl = space6;     // 24
  static const double xxxl = space8;    // 32
  static const double xxxxl = space10;  // 40
  static const double xxxxxl = space12; // 48
  static const double xxxxxxl = space16; // 64

  // Layout-specific spacing
  static const double screenPadding = space6;        // 24
  static const double screenPaddingSmall = space4;   // 16
  static const double screenPaddingLarge = space8;   // 32
  static const double cardPadding = space4;          // 16
  static const double cardPaddingLarge = space6;     // 24
  static const double sectionSpacing = space8;       // 32
  static const double componentSpacing = space4;     // 16
  static const double itemSpacing = space3;          // 12
  static const double inlineSpacing = space2;        // 8
  static const double inlineSpacingSmall = space1;   // 4

  // Component heights
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 80.0;
  static const double fabSize = 56.0;
  static const double fabExtendedHeight = 56.0;
  static const double bottomSheetHandleHeight = 4.0;
  static const double bottomSheetHandleWidth = 40.0;
  static const double inputHeight = 48.0;
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 40.0;
  static const double chipHeight = 32.0;

  // Animation durations
  static const Duration durationInstant = Duration(milliseconds: 50);
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 200);
  static const Duration durationSlow = Duration(milliseconds: 300);
  static const Duration durationVerySlow = Duration(milliseconds: 500);

  // Animation curves
  static const Curve curveStandard = Curves.easeInOut;
  static const Curve curveEmphasized = Curves.easeOutCubic;
  static const Curve curveDecelerate = Curves.decelerate;
  static const Curve curveAccelerate = Curves.easeIn;
  static const Curve curveSpring = Curves.elasticOut;
  static const Curve curveBounce = Curves.bounceOut;

  // Common animation configs
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve pageTransitionCurve = Curves.easeInOutCubic;

  static const Duration cardHoverDuration = Duration(milliseconds: 200);
  static const Curve cardHoverCurve = Curves.easeOutCubic;

  static const Duration buttonPressDuration = Duration(milliseconds: 100);
  static const Curve buttonPressCurve = Curves.easeOut;

  static const Duration bottomSheetDuration = Duration(milliseconds: 300);
  static const Curve bottomSheetCurve = Curves.easeOutCubic;

  static const Duration fadeInDuration = Duration(milliseconds: 200);
  static const Duration fadeOutDuration = Duration(milliseconds: 150);
  static const Curve fadeCurve = Curves.easeOut;

  static const Duration scaleInDuration = Duration(milliseconds: 200);
  static const Duration scaleOutDuration = Duration(milliseconds: 150);
  static const Curve scaleCurve = Curves.easeOutBack;

  static const Duration slideInDuration = Duration(milliseconds: 300);
  static const Duration slideOutDuration = Duration(milliseconds: 200);
  static const Curve slideCurve = Curves.easeOutCubic;

  // Staggered animations
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static const int maxStaggerItems = 10;

  // Micro-interactions
  static const Duration tapFeedback = Duration(milliseconds: 50);
  static const Duration hoverFeedback = Duration(milliseconds: 150);
  static const Duration focusFeedback = Duration(milliseconds: 100);
  static const Duration loadingPulse = Duration(milliseconds: 1000);

  // Spring animations
  static const Duration springDuration = Duration(milliseconds: 500);
  static const SpringDescription springStandard = SpringDescription(
    mass: 1.0,
    stiffness: 200.0,
    damping: 20.0,
  );
  static const SpringDescription springGentle = SpringDescription(
    mass: 1.0,
    stiffness: 150.0,
    damping: 25.0,
  );
  static const SpringDescription springSnappy = SpringDescription(
    mass: 1.0,
    stiffness: 300.0,
    damping: 20.0,
  );
}

class AppRadius {
  AppRadius._();

  // Base radius scale
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double round = 9999.0;

  // Semantic radius
  static const double button = 14.0;
  static const double buttonSmall = 10.0;
  static const double buttonLarge = 18.0;
  static const double card = 18.0;
  static const double cardSmall = 12.0;
  static const double cardLarge = 24.0;
  static const double input = 14.0;
  static const double bottomSheet = 28.0;
  static const double modal = 24.0;
  static const double fab = 28.0;
  static const double chip = 9999.0;
  static const double avatar = 9999.0;
  static const double image = 14.0;
  static const double imageSmall = 10.0;
  static const double tooltip = 10.0;
  static const double badge = 9999.0;
}

class AppShadows {
  AppShadows._();

  // Elevation levels (Material 3 inspired)
  static List<BoxShadow> get level0 => [];

  static List<BoxShadow> get level1 => [
    BoxShadow(
      color: AppColors.shadow,
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadow,
      offset: const Offset(0, 1),
      blurRadius: 3,
      spreadRadius: -1,
    ),
  ];

  static List<BoxShadow> get level2 => [
    BoxShadow(
      color: AppColors.shadow,
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadow,
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get level3 => [
    BoxShadow(
      color: AppColors.shadowMedium,
      offset: const Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadow,
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get level4 => [
    BoxShadow(
      color: AppColors.shadowStrong,
      offset: const Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadowMedium,
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get level5 => [
    BoxShadow(
      color: AppColors.shadowStrong,
      offset: const Offset(0, 12),
      blurRadius: 32,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadowStrong,
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  // Semantic shadows
  static List<BoxShadow> get none => level0;
  static List<BoxShadow> get card => level1;
  static List<BoxShadow> get cardHover => level2;
  static List<BoxShadow> get cardElevated => level3;
  static List<BoxShadow> get cardPressed => level1;
  static List<BoxShadow> get floating => level4;
  static List<BoxShadow> get modal => level5;
  static List<BoxShadow> get bottomSheet => [
    BoxShadow(
      color: AppColors.shadowStrong,
      offset: const Offset(0, -4),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];
  static List<BoxShadow> get fab => [
    BoxShadow(
      color: AppColors.shadowStrong,
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadow,
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
  static List<BoxShadow> get fabHover => [
    BoxShadow(
      color: AppColors.shadowStrong,
      offset: const Offset(0, 8),
      blurRadius: 20,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadowMedium,
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  static List<BoxShadow> get searchBar => [
    BoxShadow(
      color: AppColors.shadow,
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  static List<BoxShadow> get inner => [
    BoxShadow(
      color: AppColors.shadow,
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  // Colored shadows for brand elements
  static List<BoxShadow> get primaryGlow => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.3),
      offset: const Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.15),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get primaryGlowSubtle => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.2),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
}

class AppBorders {
  AppBorders._();

  static BorderSide get hairline => BorderSide(
    color: AppColors.divider,
    width: 0.5,
  );

  static BorderSide get thin => BorderSide(
    color: AppColors.outline,
    width: 1.0,
  );

  static BorderSide get medium => BorderSide(
    color: AppColors.outlineStrong,
    width: 1.5,
  );

  static BorderSide get thick => BorderSide(
    color: AppColors.primary,
    width: 2.0,
  );

  static BorderSide get selected => BorderSide(
    color: AppColors.primary,
    width: 2.0,
  );

  static BorderSide get error => BorderSide(
    color: AppColors.error,
    width: 1.5,
  );

  static BorderSide get focus => BorderSide(
    color: AppColors.primary,
    width: 2.0,
  );

  static BorderSide get success => BorderSide(
    color: AppColors.success,
    width: 2.0,
  );

  static BorderSide get warning => BorderSide(
    color: AppColors.warning,
    width: 2.0,
  );

  // Semantic borders
  static BorderSide get card => thin;
  static BorderSide get cardHover => medium;
  static BorderSide get input => thin;
  static BorderSide get inputFocus => focus;
  static BorderSide get inputError => error;
  static BorderSide get button => BorderSide.none;
  static BorderSide get buttonOutlined => medium;
  static BorderSide get chip => thin;
  static BorderSide get divider => BorderSide(
    color: AppColors.divider,
    width: 1.0,
  );
}

class AppMotion {
  AppMotion._();

  // Page transitions
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Curve pageTransitionCurve = Curves.easeInOutCubic;

  // Container transforms
  static const Duration containerTransform = Duration(milliseconds: 350);
  static const Curve containerTransformCurve = Curves.easeInOutCubic;

  // Fade transitions
  static const Duration fadeIn = Duration(milliseconds: 200);
  static const Duration fadeOut = Duration(milliseconds: 150);
  static const Curve fadeCurve = Curves.easeOut;

  // Scale transitions
  static const Duration scaleIn = Duration(milliseconds: 200);
  static const Duration scaleOut = Duration(milliseconds: 150);
  static const Curve scaleCurve = Curves.easeOutBack;

  // Slide transitions
  static const Duration slideIn = Duration(milliseconds: 300);
  static const Duration slideOut = Duration(milliseconds: 200);
  static const Curve slideCurve = Curves.easeOutCubic;

  // Staggered animations
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static const int maxStaggerItems = 10;

  // Micro-interactions
  static const Duration tapFeedback = Duration(milliseconds: 50);
  static const Duration hoverFeedback = Duration(milliseconds: 150);
  static const Duration focusFeedback = Duration(milliseconds: 100);
  static const Duration loadingPulse = Duration(milliseconds: 1000);

  // Spring animations
  static const Duration springDuration = Duration(milliseconds: 500);
  static const SpringDescription springStandard = SpringDescription(
    mass: 1.0,
    stiffness: 200.0,
    damping: 20.0,
  );
  static const SpringDescription springGentle = SpringDescription(
    mass: 1.0,
    stiffness: 150.0,
    damping: 25.0,
  );
  static const SpringDescription springSnappy = SpringDescription(
    mass: 1.0,
    stiffness: 300.0,
    damping: 20.0,
  );
}

class AppBreakpoints {
  AppBreakpoints._();

  static const double mobile = 0;
  static const double tablet = 600;
  static const double desktop = 900;
  static const double largeDesktop = 1200;
  static const double extraLargeDesktop = 1440;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tablet;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet &&
      MediaQuery.of(context).size.width < desktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  static double responsiveValue(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    final ld = largeDesktop ?? double.infinity;
    final dt = desktop ?? double.infinity;
    final tb = tablet ?? double.infinity;
    if (width >= ld) return largeDesktop ?? desktop ?? tablet ?? mobile;
    if (width >= dt) return desktop ?? tablet ?? mobile;
    if (width >= tb) return tablet ?? mobile;
    return mobile;
  }

  static int responsiveCrossAxisCount(BuildContext context, {
    required int mobile,
    int? tablet,
    int? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    final dt = desktop ?? double.infinity;
    final tb = tablet ?? double.infinity;
    if (width >= dt) return desktop ?? tablet ?? mobile;
    if (width >= tb) return tablet ?? mobile;
    return mobile;
  }
}
class RoadSafeSpacing {
  RoadSafeSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double xxxxl = 40.0;

  static const double screenPadding = 20.0;
  static const double cardPadding = 16.0;
  static const double sectionSpacing = 24.0;
  static const double componentSpacing = 16.0;
  static const double itemSpacing = 12.0;
  static const double inlineSpacing = 8.0;
}

class RoadSafeRadius {
  RoadSafeRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double round = 9999.0;
}

class RoadSafeShadows {
  RoadSafeShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: RoadSafeColors.shadow,
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: RoadSafeColors.shadow,
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> cardElevated = [
    BoxShadow(
      color: RoadSafeColors.shadowStrong,
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: RoadSafeColors.shadow,
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> bottomSheet = [
    BoxShadow(
      color: RoadSafeColors.shadowStrong,
      offset: Offset(0, -4),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> fab = [
    BoxShadow(
      color: RoadSafeColors.shadowStrong,
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> modal = [
    BoxShadow(
      color: RoadSafeColors.shadowStrong,
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
}

class RoadSafeBorders {
  RoadSafeBorders._();

  static const BorderSide thin = BorderSide(
    color: RoadSafeColors.border,
    width: 1.0,
  );

  static const BorderSide medium = BorderSide(
    color: RoadSafeColors.borderStrong,
    width: 1.5,
  );

  static const BorderSide thick = BorderSide(
    color: RoadSafeColors.primary,
    width: 2.0,
  );

  static const BorderSide selected = BorderSide(
    color: RoadSafeColors.primary,
    width: 2.0,
  );

  static const BorderSide error = BorderSide(
    color: RoadSafeColors.error,
    width: 1.5,
  );
}
class ApiConfig {

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/api/v1',
  );
}

class HazardType {
  static const pothole = 'POTHOLE';
  static const unmarkedBreaker = 'UNMARKED_BREAKER';
  static const illegalBreaker = 'ILLEGAL_BREAKER';
  static const waterloggedHazard = 'WATERLOGGED_HAZARD';
  static const other = 'OTHER';

  static const all = [pothole, unmarkedBreaker, illegalBreaker, waterloggedHazard, other];

  static String label(String value) {
    switch (value) {
      case pothole: return 'Pothole';
      case unmarkedBreaker: return 'Unmarked Breaker';
      case illegalBreaker: return 'Illegal Breaker';
      case waterloggedHazard: return 'Waterlogged Hazard';
      default: return 'Other';
    }
  }
}

class Severity {
  static const low = 'LOW';
  static const medium = 'MEDIUM';
  static const high = 'HIGH';
  static const critical = 'CRITICAL';

  static const all = [low, medium, high, critical];
}

class UserRole {
  static const citizen = 'CITIZEN';
  static const authority = 'AUTHORITY';
  static const admin = 'ADMIN';
}

class GeoDefaults {

  static const double defaultLat = 28.6139;
  static const double defaultLng = 77.2090;
  static const int nearbyAlertRadiusMeters = 300;
}

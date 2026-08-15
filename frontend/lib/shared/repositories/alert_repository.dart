import '../models/alert.dart';

abstract class AlertRepository {
  Future<List<SafetyAlert>> getAlerts({AlertCategory? category});
}

/// Mock implementation — swap for an ApiClient-backed impl once the
/// RoadSafe backend exposes a /alerts endpoint. Only this class changes;
/// AlertProvider and the UI stay the same.
class MockAlertRepositoryImpl implements AlertRepository {
  static final List<SafetyAlert> _mockAlerts = [
    SafetyAlert(
      id: '1',
      title: 'Flood Warning',
      description: 'Heavy rainfall and flooding reported in your area. Avoid low-lying roads and waterlogged areas.',
      location: 'Sector 18, Noida, UP',
      distanceKm: 2.4,
      severity: AlertSeverity.critical,
      category: AlertCategory.disaster,
      source: 'IMD',
      updatedAt: DateTime.now().subtract(const Duration(minutes: 8)),
      imageUrl: '',
      affectedRoads: ['Noida–Greater Noida Expressway', 'Sector 18 Main Road', 'Dadri Road'],
      isEmergency: true,
    ),
    SafetyAlert(
      id: '2',
      title: 'Heavy Rainfall',
      description: 'Expected rainfall of 90-110 mm in the next 6 hours. Carry an umbrella and drive carefully.',
      location: 'Delhi NCR',
      distanceKm: 5.6,
      severity: AlertSeverity.high,
      category: AlertCategory.weather,
      source: 'Weather Dept',
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      imageUrl: '',
      affectedRoads: [],
      isEmergency: false,
    ),
    SafetyAlert(
      id: '3',
      title: 'Dense Fog',
      description: 'Visibility less than 100 m in some areas. Drive with low beam lights.',
      location: 'Delhi–Meerut Expressway',
      distanceKm: 7.3,
      severity: AlertSeverity.medium,
      category: AlertCategory.visibility,
      source: 'Traffic Police',
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      imageUrl: '',
      affectedRoads: [],
      isEmergency: false,
    ),
    SafetyAlert(
      id: '4',
      title: 'Landslide Warning',
      description: 'Possible landslides in Uttarakhand region. Avoid hilly routes.',
      location: 'Uttarakhand',
      distanceKm: 312,
      severity: AlertSeverity.high,
      category: AlertCategory.disaster,
      source: 'Geological Survey',
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      imageUrl: '',
      affectedRoads: [],
      isEmergency: false,
    ),
    SafetyAlert(
      id: '5',
      title: 'Wildfire Alert',
      description: 'Forest fire reported near Rishikesh, UK. Smoke may affect visibility.',
      location: 'Rishikesh, Uttarakhand',
      distanceKm: 286,
      severity: AlertSeverity.medium,
      category: AlertCategory.emergency,
      source: 'Forest Dept',
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      imageUrl: '',
      affectedRoads: [],
      isEmergency: false,
    ),
    SafetyAlert(
      id: '6',
      title: 'Cyclone Update',
      description: "Cyclone 'Mocha' active in Bay of Bengal. Noida not affected.",
      location: 'Bay of Bengal',
      distanceKm: 1450,
      severity: AlertSeverity.low,
      category: AlertCategory.disaster,
      source: 'IMD',
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
      imageUrl: '',
      affectedRoads: [],
      isEmergency: false,
    ),
  ];

  @override
  Future<List<SafetyAlert>> getAlerts({AlertCategory? category}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (category == null || category == AlertCategory.all) {
      return List.unmodifiable(_mockAlerts);
    }
    return _mockAlerts.where((a) => a.category == category).toList();
  }
}

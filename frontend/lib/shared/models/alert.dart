enum AlertCategory {
  all,
  road,
  weather,
  disaster,
  visibility,
  emergency,
}

enum AlertSeverity {
  critical,
  high,
  medium,
  low,
  informational,
}

class SafetyAlert {
  final String id;
  final String title;
  final String description;
  final String location;
  final double distanceKm;
  final AlertSeverity severity;
  final AlertCategory category;
  final String source;
  final DateTime updatedAt;
  final String? imageUrl;
  final List<String> affectedRoads;
  final bool isEmergency;

  const SafetyAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.distanceKm,
    required this.severity,
    required this.category,
    required this.source,
    required this.updatedAt,
    this.imageUrl,
    this.affectedRoads = const [],
    this.isEmergency = false,
  });

  String get severityDisplay {
    switch (severity) {
      case AlertSeverity.critical:
        return 'CRITICAL';
      case AlertSeverity.high:
        return 'HIGH';
      case AlertSeverity.medium:
        return 'MEDIUM';
      case AlertSeverity.low:
        return 'LOW';
      case AlertSeverity.informational:
        return 'INFO';
    }
  }

  String get categoryDisplay {
    switch (category) {
      case AlertCategory.all:
        return 'All Alerts';
      case AlertCategory.road:
        return 'Road';
      case AlertCategory.weather:
        return 'Weather';
      case AlertCategory.disaster:
        return 'Disaster';
      case AlertCategory.visibility:
        return 'Visibility';
      case AlertCategory.emergency:
        return 'Emergency';
    }
  }

  factory SafetyAlert.fromJson(Map<String, dynamic> json) {
    return SafetyAlert(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      severity: _parseSeverity(json['severity']),
      category: _parseCategory(json['category']),
      source: json['source'] ?? '',
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      imageUrl: json['imageUrl'],
      affectedRoads: (json['affectedRoads'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isEmergency: json['isEmergency'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'distanceKm': distanceKm,
      'severity': severity.name.toUpperCase(),
      'category': category.name.toUpperCase(),
      'source': source,
      'updatedAt': updatedAt.toIso8601String(),
      'imageUrl': imageUrl,
      'affectedRoads': affectedRoads,
      'isEmergency': isEmergency,
    };
  }

  static AlertSeverity _parseSeverity(String? value) {
    switch (value?.toUpperCase()) {
      case 'CRITICAL':
        return AlertSeverity.critical;
      case 'HIGH':
        return AlertSeverity.high;
      case 'MEDIUM':
        return AlertSeverity.medium;
      case 'LOW':
        return AlertSeverity.low;
      case 'INFO':
      case 'INFORMATIONAL':
        return AlertSeverity.informational;
      default:
        return AlertSeverity.informational;
    }
  }

  static AlertCategory _parseCategory(String? value) {
    switch (value?.toUpperCase()) {
      case 'ROAD':
        return AlertCategory.road;
      case 'WEATHER':
        return AlertCategory.weather;
      case 'DISASTER':
        return AlertCategory.disaster;
      case 'VISIBILITY':
        return AlertCategory.visibility;
      case 'EMERGENCY':
        return AlertCategory.emergency;
      default:
        return AlertCategory.all;
    }
  }
}
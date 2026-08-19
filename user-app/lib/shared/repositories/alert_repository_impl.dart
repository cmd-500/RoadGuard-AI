import 'package:geolocator/geolocator.dart';
import '../models/alert.dart';
import '../models/report.dart';
import 'alert_repository.dart';
import 'report_repository.dart';

/// Live-Alerts feed backed by real reports.
///
/// A report only shows up here once an admin has reviewed it in the
/// admin-portal and marked it "Resolved" (see admin-portal's "Mark as
/// Resolved" action, which PUTs status=RESOLVED to the backend). That is
/// the app's notion of "admin approved". Until then the report stays
/// PENDING / IN_PROGRESS and is only visible on the admin dashboard.
class ApiAlertRepositoryImpl implements AlertRepository {
  final ReportRepository _reportRepository;

  ApiAlertRepositoryImpl({required ReportRepository reportRepository})
      : _reportRepository = reportRepository;

  @override
  Future<List<SafetyAlert>> getAlerts({AlertCategory? category}) async {
    final result = await _reportRepository.getReports(
      status: ReportStatus.resolved,
      limit: 50,
    );

    Position? currentPosition;
    try {
      currentPosition = await Geolocator.getLastKnownPosition();
    } catch (_) {
      // Location isn't essential for showing alerts, so ignore failures.
    }

    final alerts = result.reports.map((report) {
      final distanceKm = currentPosition != null
          ? Geolocator.distanceBetween(
                currentPosition.latitude,
                currentPosition.longitude,
                report.latitude,
                report.longitude,
              ) /
              1000
          : 0.0;

      return _toSafetyAlert(report, distanceKm);
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    if (category == null || category == AlertCategory.all) {
      return alerts;
    }
    return alerts.where((a) => a.category == category).toList();
  }

  SafetyAlert _toSafetyAlert(Report report, double distanceKm) {
    final category = _categoryFor(report.hazardType);
    final severity = _severityFor(report.severity);
    final isEmergency = category == AlertCategory.emergency ||
        severity == AlertSeverity.critical;

    return SafetyAlert(
      id: report.id,
      title: report.title.isNotEmpty ? report.title : report.hazardTypeDisplay,
      description: report.description.isNotEmpty
          ? report.description
          : 'Verified ${report.hazardTypeDisplay.toLowerCase()} reported near ${report.address}.',
      location: report.address,
      distanceKm: distanceKm,
      severity: severity,
      category: category,
      source: 'RoadGuard Admin',
      updatedAt: report.updatedAt,
      imageUrl: report.imageUrl,
      affectedRoads: report.address.isNotEmpty ? [report.address] : const [],
      isEmergency: isEmergency,
    );
  }

  AlertCategory _categoryFor(HazardType type) {
    switch (type) {
      case HazardType.fog:
        return AlertCategory.visibility;
      case HazardType.waterlogging:
      case HazardType.waterloggedHazard:
        return AlertCategory.weather;
      case HazardType.accident:
      case HazardType.emergency:
        return AlertCategory.emergency;
      case HazardType.pothole:
      case HazardType.speedBreaker:
      case HazardType.unmarkedBreaker:
      case HazardType.illegalBreaker:
      case HazardType.roadDamage:
      case HazardType.construction:
      case HazardType.other:
        return AlertCategory.road;
    }
  }

  AlertSeverity _severityFor(Severity severity) {
    switch (severity) {
      case Severity.critical:
        return AlertSeverity.critical;
      case Severity.high:
        return AlertSeverity.high;
      case Severity.medium:
        return AlertSeverity.medium;
      case Severity.low:
        return AlertSeverity.low;
    }
  }
}

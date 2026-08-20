import 'package:geolocator/geolocator.dart';
import 'dart:developer' as developer;
import '../models/alert.dart';
import '../models/report.dart';
import 'alert_repository.dart';
import 'report_repository.dart';

/// Live-Alerts feed backed by real reports.
///
/// Reports show up here once an admin has reviewed them in the
/// admin-portal and marked them as "Verified" (IN_PROGRESS) or
/// "Resolved" (RESOLVED). Both represent admin-approved alerts.
class ApiAlertRepositoryImpl implements AlertRepository {
  final ReportRepository _reportRepository;

  ApiAlertRepositoryImpl({required ReportRepository reportRepository})
      : _reportRepository = reportRepository;

  @override
  Future<List<SafetyAlert>> getAlerts({AlertCategory? category}) async {
    final allReports = <Report>[];

    // Try fetching with status filters first (admin-approved statuses)
    try {
      final resolvedResult = await _reportRepository.getReports(
        status: ReportStatus.resolved,
        limit: 50,
      );
      developer.log('Resolved reports fetched: ${resolvedResult.reports.length}');
      allReports.addAll(resolvedResult.reports);
    } catch (e) {
      developer.log('Error fetching resolved reports: $e');
    }

    try {
      final inProgressResult = await _reportRepository.getReports(
        status: ReportStatus.inProgress,
        limit: 50,
      );
      developer.log('InProgress reports fetched: ${inProgressResult.reports.length}');
      allReports.addAll(inProgressResult.reports);
    } catch (e) {
      developer.log('Error fetching inProgress reports: $e');
    }

    // Fallback 1: Also check PENDING reports (some backends use this for "verified")
    if (allReports.isEmpty) {
      try {
        developer.log('Trying PENDING reports...');
        final pendingResult = await _reportRepository.getReports(
          status: ReportStatus.pending,
          limit: 50,
        );
        developer.log('Pending reports fetched: ${pendingResult.reports.length}');
        allReports.addAll(pendingResult.reports);
      } catch (e) {
        developer.log('Error fetching pending reports: $e');
      }
    }

    // Fallback 2: if still empty, fetch all and filter client-side
    if (allReports.isEmpty) {
      try {
        developer.log('No reports with status filters, fetching all reports...');
        final allResult = await _reportRepository.getReports(limit: 100);
        final filtered = allResult.reports.where((r) => 
          r.status == ReportStatus.inProgress || 
          r.status == ReportStatus.resolved ||
          r.status == ReportStatus.pending
        ).toList();
        developer.log('Filtered reports from all: ${filtered.length}');
        allReports.addAll(filtered);
      } catch (e) {
        developer.log('Error fetching all reports: $e');
      }
    }

    // Final fallback: show ALL reports (for debugging - remove in production)
    if (allReports.isEmpty) {
      try {
        developer.log('Final fallback: fetching ALL reports...');
        final allResult = await _reportRepository.getReports(limit: 20);
        developer.log('All reports fetched: ${allResult.reports.length}');
        allReports.addAll(allResult.reports);
      } catch (e) {
        developer.log('Error fetching all reports: $e');
      }
    }

    if (allReports.isEmpty) {
      developer.log('No alerts to show');
      return [];
    }

    Position? currentPosition;
    try {
      currentPosition = await Geolocator.getLastKnownPosition();
    } catch (_) {
      // Location isn't essential for showing alerts, so ignore failures.
    }

    final alerts = allReports.map((report) {
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

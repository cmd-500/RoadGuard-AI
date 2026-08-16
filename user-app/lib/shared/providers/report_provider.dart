import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/report.dart';
import '../repositories/report_repository.dart';

class ReportProvider extends ChangeNotifier {
  final ReportRepository _repository;

  ReportProvider({required ReportRepository repository}) : _repository = repository;

  List<Report> _reports = [];
  List<NearbyReport> _nearbyReports = [];
  List<RouteHazard> _routeHazards = [];
  Report? _selectedReport;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  List<Report> get reports => _reports;
  List<NearbyReport> get nearbyReports => _nearbyReports;
  List<RouteHazard> get routeHazards => _routeHazards;
  Report? get selectedReport => _selectedReport;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  Future<void> fetchReports({
    ReportStatus? status,
    HazardType? hazardType,
    int page = 1,
  }) async {
    if (page == 1) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    try {
      final result = await _repository.getReports(
        status: status,
        hazardType: hazardType,
        page: page,
      );

      if (page == 1) {
        _reports = result.reports;
      } else {
        _reports.addAll(result.reports);
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchNearbyReports({
    required double latitude,
    required double longitude,
    double radiusMeters = 300,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _nearbyReports = await _repository.getNearbyReports(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      );
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkRoute({
    required List<Map<String, double>> waypoints,
    double bufferMeters = 150,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _routeHazards = await _repository.checkRoute(
        waypoints: waypoints,
        bufferMeters: bufferMeters,
      );
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Report?> createReport({
    required String title,
    required String description,
    required String address,
    required HazardType hazardType,
    required Severity severity,
    required double latitude,
    required double longitude,
    required String imagePath,
  }) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final report = await _repository.createReport(
        title: title,
        description: description,
        address: address,
        hazardType: hazardType,
        severity: severity,
        latitude: latitude,
        longitude: longitude,
        imageFile: File(imagePath),
      );

      _reports.insert(0, report);
      _isSubmitting = false;
      notifyListeners();
      return report;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> getReport(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedReport = await _repository.getReport(id);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSelectedReport() {
    _selectedReport = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../services/api_client.dart';

class ReportProvider extends ChangeNotifier {
  List<ReportModel> reports = [];
  List<ReportModel> nearbyHazards = [];
  List<ReportModel> routeHazards = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchReports({String? status, String? hazardType}) async {
    isLoading = true;
    notifyListeners();
    try {
      reports = await ReportService.getReports(status: status, hazardType: hazardType);
      error = null;
    } on DioException catch (e) {
      error = _messageOf(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNearby(double lat, double lng) async {
    try {
      nearbyHazards = await ReportService.getNearby(lat, lng);
      notifyListeners();
    } on DioException {
      // silent: nearby-alert polling shouldn't interrupt driving with error dialogs
    }
  }

  Future<bool> createReport({
    required String title,
    required String description,
    required String address,
    required String hazardType,
    required String severity,
    required double latitude,
    required double longitude,
    required File imageFile,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final created = await ReportService.createReport(
        title: title,
        description: description,
        address: address,
        hazardType: hazardType,
        severity: severity,
        latitude: latitude,
        longitude: longitude,
        imageFile: imageFile,
      );
      reports.insert(0, created);
      return true;
    } on DioException catch (e) {
      error = _messageOf(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> vote(String reportId, String voteType) async {
    try {
      final updated = await ReportService.castVote(reportId, voteType);
      final index = reports.indexWhere((r) => r.id == reportId);
      if (index != -1) reports[index] = updated;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      error = _messageOf(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> checkRoute(List<Map<String, double>> waypoints) async {
    isLoading = true;
    notifyListeners();
    try {
      routeHazards = await ReportService.checkRoute(waypoints);
      error = null;
    } on DioException catch (e) {
      error = _messageOf(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _messageOf(DioException e) => e.error is ApiException ? (e.error as ApiException).message : 'Something went wrong';
}

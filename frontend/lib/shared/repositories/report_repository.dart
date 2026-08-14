import 'dart:io';
import 'package:dio/dio.dart';
import '../services/api_client.dart';
import '../../models/report.dart';

abstract class ReportRepository {
  Future<Report> createReport({
    required String title,
    required String description,
    required String address,
    required HazardType hazardType,
    required Severity severity,
    required double latitude,
    required double longitude,
    required File imageFile,
  });

  Future<PaginatedReports> getReports({
    ReportStatus? status,
    HazardType? hazardType,
    int page = 1,
    int limit = 20,
  });

  Future<Report> getReport(String id);

  Future<List<NearbyReport>> getNearbyReports({
    required double latitude,
    required double longitude,
    double radiusMeters = 300,
  });

  Future<List<RouteHazard>> checkRoute({
    required List<Map<String, double>> waypoints,
    double bufferMeters = 150,
  });

  Future<Report> updateReportStatus(String id, ReportStatus status);
}

class PaginatedReports {
  final List<Report> reports;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  const PaginatedReports({
    required this.reports,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });
}

class ReportRepositoryImpl implements ReportRepository {
  final ApiClient _apiClient;

  ReportRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Report> createReport({
    required String title,
    required String description,
    required String address,
    required HazardType hazardType,
    required Severity severity,
    required double latitude,
    required double longitude,
    required File imageFile,
  }) async {
    try {
      final image = await MultipartFile.fromFile(
        imageFile.path,
        filename: 'report_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final response = await _apiClient.createReport(
        data: {
          'title': title,
          'description': description,
          'address': address,
          'hazardType': hazardType.name.toUpperCase(),
          'severity': severity.name.toUpperCase(),
          'latitude': latitude,
          'longitude': longitude,
        },
        image: image,
      );

      return Report.fromJson(response['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PaginatedReports> getReports({
    ReportStatus? status,
    HazardType? hazardType,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.getReports(
        status: status?.name.toUpperCase(),
        hazardType: hazardType?.name.toUpperCase(),
        page: page,
        limit: limit,
      );

      final List<dynamic> data = response['data'] ?? [];
      final reports = data.map((json) => Report.fromJson(json)).toList();

      return PaginatedReports(
        reports: reports,
        totalCount: response['count'] ?? reports.length,
        currentPage: page,
        totalPages: (response['count'] ?? reports.length) ~/ limit + 1,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Report> getReport(String id) async {
    try {
      final response = await _apiClient.getReport(id);
      return Report.fromJson(response['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<NearbyReport>> getNearbyReports({
    required double latitude,
    required double longitude,
    double radiusMeters = 300,
  }) async {
    try {
      final response = await _apiClient.getNearbyReports(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      );

      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => NearbyReport.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<RouteHazard>> checkRoute({
    required List<Map<String, double>> waypoints,
    double bufferMeters = 150,
  }) async {
    try {
      final response = await _apiClient.checkRoute(
        waypoints: waypoints,
        bufferMeters: bufferMeters,
      );

      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => RouteHazard.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Report> updateReportStatus(String id, ReportStatus status) async {
    try {
      final response = await _apiClient.updateReportStatus(id, status.name.toUpperCase());
      return Report.fromJson(response['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      final message = error.response?.data?['message'] ?? error.message ?? 'An error occurred';
      return Exception(message);
    }
    return Exception(error.toString());
  }
}
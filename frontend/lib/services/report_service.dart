import 'dart:io';
import 'package:dio/dio.dart';
import '../models/report_model.dart';
import 'api_client.dart';

class ReportService {
  static Future<ReportModel> createReport({
    required String title,
    required String description,
    required String address,
    required String hazardType,
    required String severity,
    required double latitude,
    required double longitude,
    required File imageFile,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'address': address,
      'hazardType': hazardType,
      'severity': severity,
      'latitude': latitude,
      'longitude': longitude,
      'image': await MultipartFile.fromFile(imageFile.path),
    });

    final res = await ApiClient.instance.post('/reports', data: formData);
    return ReportModel.fromJson(res.data['data']);
  }

  static Future<List<ReportModel>> getReports({String? status, String? hazardType}) async {
    final res = await ApiClient.instance.get('/reports', queryParameters: {
      if (status != null) 'status': status,
      if (hazardType != null) 'hazardType': hazardType,
    });
    return (res.data['data'] as List).map((e) => ReportModel.fromJson(e)).toList();
  }

  static Future<List<ReportModel>> getNearby(double latitude, double longitude, {int? radiusMeters}) async {
    final res = await ApiClient.instance.get('/reports/nearby', queryParameters: {
      'latitude': latitude,
      'longitude': longitude,
      if (radiusMeters != null) 'radiusMeters': radiusMeters,
    });
    return (res.data['data'] as List).map((e) => ReportModel.fromJson(e)).toList();
  }

  static Future<ReportModel> castVote(String reportId, String voteType) async {
    final res = await ApiClient.instance.post('/reports/$reportId/vote', data: {'voteType': voteType});
    return ReportModel.fromJson(res.data['data']);
  }

  static Future<ReportModel> updateStatus(String reportId, String status) async {
    final res = await ApiClient.instance.patch('/reports/$reportId/status', data: {'status': status});
    return ReportModel.fromJson(res.data['data']);
  }

  static Future<List<ReportModel>> checkRoute(List<Map<String, double>> waypoints, {int? bufferMeters}) async {
    final res = await ApiClient.instance.post('/routes/check', data: {
      'waypoints': waypoints,
      if (bufferMeters != null) 'bufferMeters': bufferMeters,
    });
    return (res.data['data'] as List).map((e) => ReportModel.fromRouteCheckJson(e)).toList();
  }
}

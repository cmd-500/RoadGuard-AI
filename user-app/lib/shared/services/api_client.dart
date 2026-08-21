import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {

  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/api/v1',
  );
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient({
    Dio? dio,
    FlutterSecureStorage? storage,
  })  : _dio = dio ?? Dio(),
        _storage = storage ?? const FlutterSecureStorage() {
    _init();
  }

  void _init() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.headers['Content-Type'] = 'application/json';

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: _authTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final token = await _storage.read(key: _authTokenKey);
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } else {
              await _clearTokens();
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: _refreshTokenKey);
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];
        await _storage.write(key: _authTokenKey, value: accessToken);
        await _storage.write(key: _refreshTokenKey, value: newRefreshToken);
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: _authTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _authTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: _authTokenKey);
  }

  Future<void> clearTokens() async {
    await _clearTokens();
  }

  Dio get dio => _dio;

  //Auth
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    }).then((r) => r.data);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    }).then((r) => r.data);
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) {
    return _dio.post('/auth/refresh', data: {'refreshToken': refreshToken}).then((r) => r.data);
  }

  //Reports
  Future<Map<String, dynamic>> createReport({
    required Map<String, dynamic> data,
    required MultipartFile image,
  }) {
    final formData = FormData.fromMap({
      'data': MultipartFile.fromString(
        jsonEncode(data),
        contentType: DioMediaType('application', 'json'),
      ),
      'image': image,
    });
    return _dio.post('/reports', data: formData).then((r) => r.data);
  }

  Future<Map<String, dynamic>> getReports({
    String? status,
    String? hazardType,
    int page = 1,
    int limit = 20,
  }) {
    return _dio.get('/reports', queryParameters: {
      if (status != null) 'status': status,
      if (hazardType != null) 'hazardType': hazardType,
      // Spring's Pageable is 0-indexed and expects `size`, not `limit`.
      // Our `page` parameter is 1-indexed for callers, so subtract 1 here.
      'page': page - 1,
      'size': limit,
    }).then((r) => r.data);
  }

  Future<Map<String, dynamic>> getReport(String id) {
    return _dio.get('/reports/$id').then((r) => r.data);
  }

  Future<Map<String, dynamic>> getNearbyReports({
    required double latitude,
    required double longitude,
    double radiusMeters = 300,
  }) {
    return _dio.get('/reports/nearby', queryParameters: {
      'latitude': latitude,
      'longitude': longitude,
      'radiusMeters': radiusMeters,
    }).then((r) => r.data);
  }

  Future<Map<String, dynamic>> checkRoute({
    required List<Map<String, double>> waypoints,
    double bufferMeters = 150,
  }) {
    return _dio.post('/reports/check-route', data: {
      'waypoints': waypoints,
      'bufferMeters': bufferMeters,
    }).then((r) => r.data);
  }

  Future<Map<String, dynamic>> updateReportStatus(String id, String status) {
    return _dio.put('/reports/$id/status', data: {'status': status}).then((r) => r.data);
  }

  //Votes
  Future<Map<String, dynamic>> castVote(String reportId, String voteType) {
    return _dio.post('/reports/$reportId/votes', data: {'voteType': voteType}).then((r) => r.data);
  }

  Future<Map<String, dynamic>> getVoteStatus(String reportId) {
    return _dio.get('/reports/$reportId/votes/me').then((r) => r.data);
  }
}
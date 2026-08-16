import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../services/api_client.dart';
import '../models/user.dart';

abstract class AuthRepository {
  Future<AuthResult> register(String name, String email, String password);
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> refreshToken();
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isLoggedIn();
}

class AuthResult {
  final bool success;
  final User? user;
  final String? accessToken;
  final String? refreshToken;
  final String? errorMessage;

  const AuthResult._({
    required this.success,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.errorMessage,
  });

  factory AuthResult.success(User user, String accessToken, String refreshToken) {
    return AuthResult._(
      success: true,
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  factory AuthResult.failure(String errorMessage) {
    return AuthResult._(
      success: false,
      errorMessage: errorMessage,
    );
  }
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;
  User? _cachedUser;

  AuthRepositoryImpl({
    required ApiClient apiClient,
    FlutterSecureStorage? storage,
  })  : _apiClient = apiClient,
        _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<AuthResult> register(String name, String email, String password) async {
    try {
      final response = await _apiClient.register(name: name, email: email, password: password);
      final user = User.fromJson(response['user']);
      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];

      await _apiClient.setTokens(accessToken, refreshToken);
      _cachedUser = user;

      return AuthResult.success(user, accessToken, refreshToken);
    } catch (e) {
      return AuthResult.failure(_extractErrorMessage(e));
    }
  }

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _apiClient.login(email: email, password: password);
      final user = User.fromJson(response['user']);
      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];

      await _apiClient.setTokens(accessToken, refreshToken);
      _cachedUser = user;

      return AuthResult.success(user, accessToken, refreshToken);
    } catch (e) {
      return AuthResult.failure(_extractErrorMessage(e));
    }
  }

  @override
  Future<AuthResult> refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) {
        return AuthResult.failure('No refresh token available');
      }

      final response = await _apiClient.refreshToken(refreshToken);
      final user = User.fromJson(response['user']);
      final accessToken = response['accessToken'];
      final newRefreshToken = response['refreshToken'];

      await _apiClient.setTokens(accessToken, newRefreshToken);
      _cachedUser = user;

      return AuthResult.success(user, accessToken, newRefreshToken);
    } catch (e) {
      await logout();
      return AuthResult.failure('Session expired. Please login again.');
    }
  }

  @override
  Future<void> logout() async {
    _cachedUser = null;
    await _apiClient.clearTokens();
  }

  @override
  Future<User?> getCurrentUser() async {
    if (_cachedUser != null) return _cachedUser;

    final token = await _apiClient.getAccessToken();
    if (token == null) return null;

    try {
      final response = await _apiClient.refreshToken(await _storage.read(key: 'refresh_token') ?? '');
      _cachedUser = User.fromJson(response['user']);
      return _cachedUser;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _apiClient.getAccessToken();
    return token != null;
  }

  String _extractErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null) {
        return error.response?.data['message'] ?? error.message ?? 'An error occurred';
      }
      return error.message ?? 'Network error';
    }
    return error.toString();
  }
}
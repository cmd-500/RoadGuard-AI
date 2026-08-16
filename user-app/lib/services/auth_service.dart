import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'api_client.dart';
import 'storage_service.dart';

class AuthService {
  static Future<UserModel> register(String name, String email, String password) async {
    final res = await ApiClient.instance.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    return _persistAndReturn(res.data);
  }

  static Future<UserModel> login(String email, String password) async {
    final res = await ApiClient.instance.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return _persistAndReturn(res.data);
  }

  static Future<UserModel?> restoreSession() async {
    final token = await StorageService.getToken();
    if (token == null) return null;
    try {
      final res = await ApiClient.instance.get('/auth/me');
      return UserModel.fromJson(res.data['user']);
    } on DioException {
      await StorageService.clear();
      return null;
    }
  }

  static Future<void> logout() => StorageService.clear();

  static Future<UserModel> _persistAndReturn(Map<String, dynamic> data) async {
    await StorageService.saveToken(data['token']);
    return UserModel.fromJson(data['user']);
  }
}

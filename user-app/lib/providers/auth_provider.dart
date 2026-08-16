import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus status = AuthStatus.unknown;
  UserModel? user;
  String? error;
  bool isLoading = false;

  Future<void> restoreSession() async {
    user = await AuthService.restoreSession();
    status = user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> login(String email, String password) => _run(() => AuthService.login(email, password));

  Future<bool> register(String name, String email, String password) =>
      _run(() => AuthService.register(name, email, password));

  Future<void> logout() async {
    await AuthService.logout();
    user = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> _run(Future<UserModel> Function() action) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      user = await action();
      status = AuthStatus.authenticated;
      return true;
    } on DioException catch (e) {
      error = e.error is ApiException ? (e.error as ApiException).message : e.message;
      return false;
    } catch (e) {
      error = 'Something went wrong';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

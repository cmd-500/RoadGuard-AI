import 'package:flutter/foundation.dart';
import '../../repositories/auth_repository.dart';
import '../../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider({required AuthRepository repository}) : _repository = repository;

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _repository.getCurrentUser();
    } catch (_) {
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.register(name, email, password);

    _isLoading = false;

    if (result.success) {
      _user = result.user;
      notifyListeners();
      return true;
    } else {
      _error = result.errorMessage;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.login(email, password);

    _isLoading = false;

    if (result.success) {
      _user = result.user;
      notifyListeners();
      return true;
    } else {
      _error = result.errorMessage;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
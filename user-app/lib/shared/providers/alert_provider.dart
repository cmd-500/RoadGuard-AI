import 'package:flutter/foundation.dart';
import '../models/alert.dart';
import '../repositories/alert_repository.dart';

class AlertProvider extends ChangeNotifier {
  final AlertRepository _repository;

  AlertProvider({required AlertRepository repository}) : _repository = repository;

  List<SafetyAlert> _alerts = [];
  AlertCategory _selectedCategory = AlertCategory.all;
  bool _isLoading = false;
  String? _error;

  List<SafetyAlert> get alerts => _alerts;
  AlertCategory get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<SafetyAlert> get emergencyAlerts => _alerts.where((a) => a.isEmergency).toList();
  List<SafetyAlert> get otherAlerts => _alerts.where((a) => !a.isEmergency).toList();

  List<String> get affectedRoads => emergencyAlerts
      .expand((a) => a.affectedRoads)
      .toSet()
      .toList();

  Future<void> fetchAlerts({AlertCategory? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _alerts = await _repository.getAlerts(category: category ?? _selectedCategory);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(AlertCategory category) {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    fetchAlerts(category: category);
  }
}

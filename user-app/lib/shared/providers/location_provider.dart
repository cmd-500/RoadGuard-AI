import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = false;
  String? _error;
  LocationPermission _permissionStatus = LocationPermission.denied;

  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  bool get isLoading => _isLoading;
  String? get error => _error;
  LocationPermission get permissionStatus => _permissionStatus;

  Future<void> requestPermission() async {
    _isLoading = true;
    _safeNotify();

    _permissionStatus = await Geolocator.checkPermission();
    if (_permissionStatus == LocationPermission.denied) {
      _permissionStatus = await Geolocator.requestPermission();
    }

    _isLoading = false;
    _safeNotify();
  }

  Future<void> getCurrentLocation() async {
    if (_permissionStatus == LocationPermission.denied ||
        _permissionStatus == LocationPermission.deniedForever) {
      await requestPermission();
      if (_permissionStatus == LocationPermission.denied ||
          _permissionStatus == LocationPermission.deniedForever) {
        _error = 'Location permission denied';
        _safeNotify();
        return;
      }
    }

    _isLoading = true;
    _safeNotify();

    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (_currentPosition != null) {
        _currentAddress = await _getAddressFromPosition(_currentPosition!);
      }
    } catch (e) {
      _error = 'Failed to get location: ${e.toString()}';
    }

    _isLoading = false;
    _safeNotify();
  }

  void _safeNotify() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) notifyListeners();
    });
  }

  bool get mounted => true;

  Future<String> _getAddressFromPosition(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ].where((s) => s?.isNotEmpty ?? false).join(', ');
      }
    } catch (_) {}
    return '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
  }

  Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ].where((s) => s?.isNotEmpty ?? false).join(', ');
      }
    } catch (_) {}
    return null;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
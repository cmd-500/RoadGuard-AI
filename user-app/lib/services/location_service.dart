import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  static Future<Position?> getCurrentPosition() async {
    if (!await ensurePermission()) return null;
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  static Stream<Position> positionStream({int distanceFilterMeters = 15}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: distanceFilterMeters),
    );
  }
}

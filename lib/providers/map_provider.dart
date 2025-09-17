import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class MapProvider extends ChangeNotifier {
  Position? currentLocation;

  // ✅ Fetch current location
  Future<void> fetchCurrentLocation() async {
    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied");
      }

      // Get current location
      currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching location: $e");
      }
    }
  }
}

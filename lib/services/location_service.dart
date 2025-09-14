import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  // Get current location
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kDebugMode) {
          print('❌ Location services are disabled');
        }
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            print('❌ Location permissions are denied');
          }
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          print('❌ Location permissions are permanently denied');
        }
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting current location: $e');
      }
      return null;
    }
  }

  // Start location tracking
  static Stream<Position> startLocationTracking() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }

  // Stop location tracking
  static void stopLocationTracking() {
    // This is handled automatically by the stream
  }

  // Check location permissions
  static Future<bool> checkLocationPermissions() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse ||
             permission == LocationPermission.always;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking location permissions: $e');
      }
      return false;
    }
  }

  // Request location permissions
  static Future<bool> requestLocationPermissions() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      return permission == LocationPermission.whileInUse ||
             permission == LocationPermission.always;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error requesting location permissions: $e');
      }
      return false;
    }
  }

  // Calculate distance between two points
  static double calculateDistance(
    double lat1, double lon1, double lat2, double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // Check if location is within radius
  static bool isWithinRadius(
    double lat1, double lon1, double lat2, double lon2, double radiusInMeters,
  ) {
    double distance = calculateDistance(lat1, lon1, lat2, lon2);
    return distance <= radiusInMeters;
  }

  // Get location accuracy
  static String getLocationAccuracy(double accuracy) {
    if (accuracy <= 5) {
      return 'Excellent';
    } else if (accuracy <= 10) {
      return 'Good';
    } else if (accuracy <= 20) {
      return 'Fair';
    } else {
      return 'Poor';
    }
  }

  // Format coordinates
  static String formatCoordinates(double latitude, double longitude) {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }
}
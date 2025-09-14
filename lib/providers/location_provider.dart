import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

// Location Service Provider
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// Current Location Provider
final currentLocationProvider = FutureProvider<Position?>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  return await locationService.getCurrentLocation();
});

// Location Stream Provider
final locationStreamProvider = StreamProvider<Position>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  return locationService.startLocationTracking();
});

// Location Permissions Provider
final locationPermissionsProvider = FutureProvider<bool>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  return await locationService.checkLocationPermissions();
});

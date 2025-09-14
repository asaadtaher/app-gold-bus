import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/route_service.dart';

// Route Service Provider
final routeServiceProvider = Provider<RouteService>((ref) {
  return RouteService();
});

// Routes Stream Provider
final routesStreamProvider = StreamProvider((ref) {
  final routeService = ref.watch(routeServiceProvider);
  return routeService.streamRoutes();
});

// Active Routes Stream Provider
final activeRoutesStreamProvider = StreamProvider((ref) {
  final routeService = ref.watch(routeServiceProvider);
  return routeService.streamRoutes();
});

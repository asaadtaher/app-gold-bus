import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/security_service.dart';
import '../services/device_security_service.dart';

// Security Service Provider
final securityServiceProvider = Provider<SecurityService>((ref) {
  return SecurityService();
});

// Device Security Service Provider
final deviceSecurityServiceProvider = Provider<DeviceSecurityService>((ref) {
  return DeviceSecurityService();
});

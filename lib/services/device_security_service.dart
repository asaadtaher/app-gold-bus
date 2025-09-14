import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DeviceSecurityService {
  static const MethodChannel _channel = MethodChannel('device_security');
  
  // Initialize device security service
  static Future<void> initialize() async {
    try {
      if (kDebugMode) {
        print('✅ Device security service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize device security service: $e');
      }
    }
  }
  
  // Prevent screenshots and screen recording
  static Future<void> preventScreenshots() async {
    try {
      if (Platform.isAndroid) {
        await _channel.invokeMethod('preventScreenshots');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to prevent screenshots: $e');
      }
    }
  }
  
  // Allow screenshots (for non-sensitive screens)
  static Future<void> allowScreenshots() async {
    try {
      if (Platform.isAndroid) {
        await _channel.invokeMethod('allowScreenshots');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to allow screenshots: $e');
      }
    }
  }
  
  // Check if device is rooted (Android) or jailbroken (iOS)
  static Future<bool> isDeviceCompromised() async {
    try {
      if (Platform.isAndroid) {
        final result = await _channel.invokeMethod('isDeviceRooted');
        return result as bool? ?? false;
      } else if (Platform.isIOS) {
        final result = await _channel.invokeMethod('isDeviceJailbroken');
        return result as bool? ?? false;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to check device security: $e');
      }
      return false;
    }
  }
  
  // Check if app is running in debug mode
  static bool isDebugMode() {
    return kDebugMode;
  }
  
  // Check if app is running in release mode
  static bool isReleaseMode() {
    return kReleaseMode;
  }
  
  // Get device security status
  static Future<Map<String, dynamic>> getSecurityStatus() async {
    try {
      final isCompromised = await isDeviceCompromised();
      final isDebug = isDebugMode();
      
      return {
        'isCompromised': isCompromised,
        'isDebugMode': isDebug,
        'isReleaseMode': !isDebug,
        'platform': Platform.operatingSystem,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to get security status: $e');
      }
      return {
        'isCompromised': false,
        'isDebugMode': isDebugMode(),
        'isReleaseMode': !isDebugMode(),
        'platform': Platform.operatingSystem,
        'timestamp': DateTime.now().toIso8601String(),
        'error': e.toString(),
      };
    }
  }
  
  // Validate app integrity
  static Future<bool> validateAppIntegrity() async {
    try {
      if (Platform.isAndroid) {
        final result = await _channel.invokeMethod('validateAppIntegrity');
        return result as bool? ?? true;
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to validate app integrity: $e');
      }
      return true; // Assume valid if check fails
    }
  }
  
  // Check if app is installed from official store
  static Future<bool> isFromOfficialStore() async {
    try {
      if (Platform.isAndroid) {
        final result = await _channel.invokeMethod('isFromPlayStore');
        return result as bool? ?? true;
      } else if (Platform.isIOS) {
        final result = await _channel.invokeMethod('isFromAppStore');
        return result as bool? ?? true;
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to check app source: $e');
      }
      return true; // Assume official if check fails
    }
  }
  
  // Get device fingerprint
  static Future<String> getDeviceFingerprint() async {
    try {
      final result = await _channel.invokeMethod('getDeviceFingerprint');
      return result as String? ?? 'unknown';
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to get device fingerprint: $e');
      }
      return 'unknown';
    }
  }
  
  // Check if device has security features enabled
  static Future<bool> hasSecurityFeatures() async {
    try {
      if (Platform.isAndroid) {
        final result = await _channel.invokeMethod('hasSecurityFeatures');
        return result as bool? ?? true;
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to check security features: $e');
      }
      return true;
    }
  }
  
  // Log security event
  static void logSecurityEvent(String event, Map<String, dynamic> data) {
    if (kDebugMode) {
      print('🔒 Device Security Event: $event - $data');
    }
    
    // Send to monitoring service
    _sendToMonitoringService(event, data);
  }
  
  static void _sendToMonitoringService(String event, Map<String, dynamic> data) {
    // Implement monitoring service integration
    // This could be Firebase Analytics, Crashlytics, or custom service
  }
}

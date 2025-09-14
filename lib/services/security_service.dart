import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();
  
  late Encrypter _encrypter;
  late Key _key;
  late IV _iv;
  
  // Initialize encryption
  Future<void> initialize() async {
    try {
      final keyString = AppConfig.encryptionKey;
      if (keyString.isEmpty) {
        throw Exception('Encryption key not found');
      }
      
      _key = Key.fromBase64(keyString);
      _iv = IV.fromLength(16);
      _encrypter = Encrypter(AES(_key));
      
      if (kDebugMode) {
        print('✅ Security service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize security service: $e');
      }
      rethrow;
    }
  }
  
  // Encrypt sensitive data
  String encryptData(String data) {
    try {
      final encrypted = _encrypter.encrypt(data, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Encryption failed: $e');
      }
      return data; // Return original data if encryption fails
    }
  }
  
  // Decrypt sensitive data
  String decryptData(String encryptedData) {
    try {
      final encrypted = Encrypted.fromBase64(encryptedData);
      final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
      return decrypted;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Decryption failed: $e');
      }
      return encryptedData; // Return encrypted data if decryption fails
    }
  }
  
  // Hash password
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  // Generate secure token
  String generateSecureToken() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final bytes = utf8.encode(random);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  // Validate API key
  bool validateApiKey(String apiKey) {
    // Implement API key validation logic
    return apiKey.isNotEmpty && apiKey.length >= 32;
  }
  
  // Sanitize user input
  String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'[<>"\']'), '') // Remove potentially dangerous characters
        .trim();
  }
  
  // Validate email format
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
  
  // Validate phone number format
  bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phone);
  }
  
  // Generate secure filename
  String generateSecureFilename(String originalName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final hash = sha256.convert(utf8.encode(originalName + timestamp.toString()));
    final extension = originalName.split('.').last;
    return '${hash.toString().substring(0, 16)}.$extension';
  }
  
  // Check if device is rooted/jailbroken (Android)
  Future<bool> isDeviceSecure() async {
    // Implement device security checks
    // This would require platform-specific code
    return true; // Placeholder
  }
  
  // Log security events
  void logSecurityEvent(String event, Map<String, dynamic> data) {
    if (AppConfig.enableLogging) {
      final logData = {
        'timestamp': DateTime.now().toIso8601String(),
        'event': event,
        'data': data,
        'device_id': 'device_identifier', // Implement device ID generation
      };
      
      if (kDebugMode) {
        print('🔒 Security Event: $logData');
      }
      
      // Send to monitoring service
      _sendToMonitoringService(logData);
    }
  }
  
  void _sendToMonitoringService(Map<String, dynamic> logData) {
    // Implement monitoring service integration
    // This could be Firebase Analytics, Crashlytics, or custom service
  }
}

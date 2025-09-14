import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _envFile = 'assets/.env';
  
  // Firebase Configuration
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';
  static String get firebaseMessagingSenderId => dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseStorageBucket => dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';
  
  // Google Sign-In
  static String get googleClientIdAndroid => dotenv.env['GOOGLE_CLIENT_ID_ANDROID'] ?? '';
  static String get googleClientIdIos => dotenv.env['GOOGLE_CLIENT_ID_IOS'] ?? '';
  
  // Security Keys
  static String get encryptionKey => dotenv.env['ENCRYPTION_KEY'] ?? '';
  static String get jwtSecret => dotenv.env['JWT_SECRET'] ?? '';
  
  // API Endpoints
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get firebaseFunctionsUrl => dotenv.env['FIREBASE_FUNCTIONS_URL'] ?? '';
  
  // App Configuration
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static bool get debugMode => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true' || kDebugMode;
  static bool get enableLogging => dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';
  static bool get enableAnalytics => dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';
  
  // Initialize configuration
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: _envFile);
      if (kDebugMode) {
        print('✅ App configuration loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to load app configuration: $e');
      }
      // Fallback to hardcoded values for development
      await _loadFallbackConfig();
    }
  }
  
  static Future<void> _loadFallbackConfig() async {
    // Fallback configuration for development
    if (kDebugMode) {
      print('⚠️ Using fallback configuration');
    }
  }
  
  // Security validation
  static bool validateConfig() {
    final requiredKeys = [
      'FIREBASE_API_KEY',
      'FIREBASE_PROJECT_ID',
      'FIREBASE_APP_ID',
    ];
    
    for (final key in requiredKeys) {
      if (dotenv.env[key]?.isEmpty ?? true) {
        if (kDebugMode) {
          print('❌ Missing required configuration: $key');
        }
        return false;
      }
    }
    
    return true;
  }
}

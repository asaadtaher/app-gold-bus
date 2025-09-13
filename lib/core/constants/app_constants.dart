class AppConstants {
  // App Info
  static const String appName = 'Gold Bus';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const int primaryColorValue = 0xFFFFD700; // Gold
  static const int secondaryColorValue = 0xFF000000; // Black
  static const int accentColorValue = 0xFF333333; // Dark Gray
  
  // API
  static const String baseUrl = 'https://api.goldbus.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Maps
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String busesCollection = 'buses';
  static const String studentsCollection = 'students';
  static const String routesCollection = 'routes';
  static const String notificationsCollection = 'notifications';
  
  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String busImagesPath = 'bus_images';
  static const String studentImagesPath = 'student_images';
  
  // Tracking
  static const Duration locationUpdateInterval = Duration(seconds: 3);
  static const Duration backgroundLocationInterval = Duration(seconds: 10);
  static const double geofenceRadius = 100.0; // meters
  
  // Notifications
  static const String checkInChannelId = 'check_in_channel';
  static const String checkOutChannelId = 'check_out_channel';
  static const String emergencyChannelId = 'emergency_channel';
  static const String generalChannelId = 'general_channel';
  
  // Shared Preferences Keys
  static const String userTokenKey = 'user_token';
  static const String userRoleKey = 'user_role';
  static const String selectedLanguageKey = 'selected_language';
  static const String themeModeKey = 'theme_mode';
  static const String notificationsEnabledKey = 'notifications_enabled';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxPhoneLength = 15;
  
  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultElevation = 2.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Image Sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;
  
  // Profile Image
  static const double profileImageSize = 80.0;
  static const double smallProfileImageSize = 40.0;
  static const double largeProfileImageSize = 120.0;
  
  // Map Markers
  static const double mapMarkerSize = 30.0;
  static const double smallMapMarkerSize = 20.0;
  static const double largeMapMarkerSize = 40.0;
}


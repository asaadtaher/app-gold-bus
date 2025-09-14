class AppConstants {
  // App Information
  static const String appName = 'Gold Bus';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'School Transportation Management App';
  
  // Collections
  static const String usersCollection = 'users';
  static const String studentsCollection = 'students';
  static const String busesCollection = 'buses';
  static const String routesCollection = 'routes';
  static const String absencesCollection = 'absences';
  static const String chatMessagesCollection = 'chat_messages';
  static const String notificationsCollection = 'notifications';
  static const String reportsCollection = 'reports';
  static const String auditLogsCollection = 'audit_logs';
  
  // User Roles
  static const String parentRole = 'parent';
  static const String driverRole = 'driver';
  static const String supervisorRole = 'supervisor';
  static const String adminRole = 'admin';
  
  // Absence Types
  static const String goingOnly = 'goingOnly';
  static const String returningOnly = 'returningOnly';
  static const String both = 'both';
  
  // Vehicle Types
  static const List<String> vehicleTypes = [
    'ملاكي',
    'ميكروباص',
    'هاي اس',
    'باص 28',
    'كوستر',
    'ملاكي 7 راكب',
    'H1',
    'باص 50 راكب',
    'آخر',
  ];
  
  // Contact Information
  static const String adminPhone1 = '01204746897';
  static const String adminPhone2 = '01203935169';
  
  // Map Configuration
  static const double defaultLatitude = 30.0444;
  static const double defaultLongitude = 31.2357;
  static const double defaultZoom = 15.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 8.0;
  static const double smallRadius = 4.0;
  static const double largeRadius = 12.0;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 200;
  
  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String driverLicensesPath = 'driver_licenses';
  static const String vehicleLicensesPath = 'vehicle_licenses';
  static const String busImagesPath = 'bus_images';
  static const String studentImagesPath = 'student_images';
  
  // Error Messages
  static const String networkError = 'خطأ في الاتصال بالإنترنت';
  static const String unknownError = 'حدث خطأ غير متوقع';
  static const String permissionDenied = 'تم رفض الصلاحية';
  static const String userNotFound = 'المستخدم غير موجود';
  static const String invalidCredentials = 'بيانات الدخول غير صحيحة';
  
  // Success Messages
  static const String loginSuccess = 'تم تسجيل الدخول بنجاح';
  static const String registrationSuccess = 'تم التسجيل بنجاح';
  static const String updateSuccess = 'تم التحديث بنجاح';
  static const String deleteSuccess = 'تم الحذف بنجاح';
  static const String saveSuccess = 'تم الحفظ بنجاح';
}
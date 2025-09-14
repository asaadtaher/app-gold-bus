import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  static const List<Locale> supportedLocales = [
    Locale('ar', ''),
    Locale('en', ''),
  ];
  
  // Common
  String get appName => 'Gold Bus';
  String get loading => 'جاري التحميل...';
  String get error => 'خطأ';
  String get success => 'نجح';
  String get cancel => 'إلغاء';
  String get confirm => 'تأكيد';
  String get save => 'حفظ';
  String get edit => 'تعديل';
  String get delete => 'حذف';
  String get add => 'إضافة';
  String get search => 'بحث';
  String get filter => 'تصفية';
  String get sort => 'ترتيب';
  String get refresh => 'تحديث';
  String get back => 'رجوع';
  String get next => 'التالي';
  String get previous => 'السابق';
  String get done => 'تم';
  String get close => 'إغلاق';
  String get ok => 'موافق';
  String get yes => 'نعم';
  String get no => 'لا';
  
  // Authentication
  String get login => 'تسجيل الدخول';
  String get register => 'تسجيل';
  String get logout => 'تسجيل الخروج';
  String get email => 'البريد الإلكتروني';
  String get password => 'كلمة المرور';
  String get confirmPassword => 'تأكيد كلمة المرور';
  String get phone => 'رقم الهاتف';
  String get name => 'الاسم';
  String get forgotPassword => 'نسيت كلمة المرور؟';
  String get resetPassword => 'إعادة تعيين كلمة المرور';
  String get signInWithGoogle => 'تسجيل الدخول بـ Google';
  
  // User Roles
  String get parent => 'ولي أمر';
  String get driver => 'سائق';
  String get supervisor => 'مشرفة';
  String get admin => 'إدارة';
  
  // Navigation
  String get home => 'الرئيسية';
  String get map => 'الخريطة';
  String get students => 'الطلاب';
  String get buses => 'الحافلات';
  String get reports => 'التقارير';
  String get settings => 'الإعدادات';
  String get profile => 'الملف الشخصي';
  String get chat => 'الدردشة';
  
  // Map
  String get liveTracking => 'المتابعة المباشرة';
  String get busLocation => 'موقع الحافلة';
  String get myLocation => 'موقعي';
  String get route => 'المسار';
  String get distance => 'المسافة';
  String get estimatedTime => 'الوقت المتوقع';
  
  // Students
  String get studentName => 'اسم الطالب';
  String get studentGrade => 'المرحلة';
  String get studentAddress => 'عنوان الطالب';
  String get parentName => 'اسم ولي الأمر';
  String get parentPhone => 'هاتف ولي الأمر';
  String get addStudent => 'إضافة طالب';
  String get editStudent => 'تعديل الطالب';
  String get deleteStudent => 'حذف الطالب';
  String get studentDetails => 'تفاصيل الطالب';
  
  // Absence
  String get absenceReport => 'بلاغ غياب';
  String get absenceType => 'نوع الغياب';
  String get goingOnly => 'ذهاب فقط';
  String get returningOnly => 'عودة فقط';
  String get both => 'ذهاب وعودة';
  String get reason => 'السبب';
  String get reportAbsence => 'إبلاغ غياب';
  
  // Buses
  String get busNumber => 'رقم الحافلة';
  String get busName => 'اسم الحافلة';
  String get driverName => 'اسم السائق';
  String get capacity => 'السعة';
  String get addBus => 'إضافة حافلة';
  String get editBus => 'تعديل الحافلة';
  String get deleteBus => 'حذف الحافلة';
  String get busDetails => 'تفاصيل الحافلة';
  
  // Driver Registration
  String get driverRegistration => 'تسجيل السائق';
  String get personalInfo => 'البيانات الشخصية';
  String get vehicleInfo => 'بيانات المركبة';
  String get fullName => 'الاسم الثلاثي';
  String get address => 'العنوان';
  String get vehicleType => 'نوع المركبة';
  String get vehicleModel => 'موديل المركبة';
  String get driverLicense => 'رخصة السائق';
  String get vehicleLicense => 'رخصة المركبة';
  String get personalImage => 'الصورة الشخصية';
  String get notes => 'ملاحظات';
  String get uploadImage => 'رفع صورة';
  String get selectImage => 'اختيار صورة';
  
  // Supervisor Registration
  String get supervisorRegistration => 'تسجيل المشرفة';
  String get schoolName => 'اسم المدرسة';
  String get supervisorPhone => 'هاتف المشرفة';
  
  // Admin Registration
  String get adminRegistration => 'تسجيل الإدارة';
  String get responsiblePerson => 'الشخص المسؤول';
  String get jobTitle => 'المسمى الوظيفي';
  String get organization => 'المؤسسة';
  String get adminPhone => 'هاتف الإدارة';
  
  // Messages
  String get interviewMessage => 'للاهتمام بالعمل في شركة Gold Bus سيتم التواصل معكم في أقرب وقت لتحديد موعد المقابلة.';
  String get activationMessage => 'سيتم التواصل معكم لتفعيل الخدمة.';
  String get approvalPending => 'في انتظار الموافقة';
  String get approved => 'تمت الموافقة';
  String get rejected => 'تم الرفض';
  
  // Errors
  String get networkError => 'خطأ في الاتصال بالإنترنت';
  String get unknownError => 'حدث خطأ غير متوقع';
  String get permissionDenied => 'تم رفض الصلاحية';
  String get userNotFound => 'المستخدم غير موجود';
  String get invalidCredentials => 'بيانات الدخول غير صحيحة';
  String get fieldRequired => 'هذا الحقل مطلوب';
  String get invalidEmail => 'البريد الإلكتروني غير صحيح';
  String get passwordTooShort => 'كلمة المرور قصيرة جداً';
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';
  
  // Success Messages
  String get loginSuccess => 'تم تسجيل الدخول بنجاح';
  String get registrationSuccess => 'تم التسجيل بنجاح';
  String get updateSuccess => 'تم التحديث بنجاح';
  String get deleteSuccess => 'تم الحذف بنجاح';
  String get saveSuccess => 'تم الحفظ بنجاح';
  String get logoutSuccess => 'تم تسجيل الخروج بنجاح';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
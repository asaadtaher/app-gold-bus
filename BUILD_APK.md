# 📱 بناء APK لتطبيق Gold Bus

## 🚀 خطوات بناء APK

### 1. التحقق من البيئة
```bash
# تحقق من Flutter
flutter doctor

# تأكد من وجود Android SDK
flutter doctor --android-licenses
```

### 2. تنظيف المشروع
```bash
# تنظيف المشروع
flutter clean

# إعادة تثبيت التبعيات
flutter pub get
```

### 3. بناء APK للتطوير
```bash
# بناء APK للتطوير (debug)
flutter build apk --debug

# أو بناء APK للإنتاج (release)
flutter build apk --release
```

### 4. موقع ملف APK
بعد البناء، ستجد ملف APK في:
```
build/app/outputs/flutter-apk/
├── app-debug.apk          # للتطوير
└── app-release.apk        # للإنتاج
```

## 📱 تثبيت APK على الهاتف

### الطريقة الأولى: USB
1. وصل الهاتف بالكمبيوتر عبر USB
2. فعّل "تصحيح USB" في إعدادات المطور
3. شغل الأمر:
```bash
flutter install
```

### الطريقة الثانية: نقل الملف
1. انسخ ملف APK إلى الهاتف
2. فعّل "مصادر غير معروفة" في إعدادات الأمان
3. افتح ملف APK وثبته

### الطريقة الثالثة: ADB
```bash
# تثبيت مباشرة عبر ADB
adb install build/app/outputs/flutter-apk/app-debug.apk
```

## 🧪 اختبار التطبيق

### اختبارات أساسية
1. **فتح التطبيق** - تأكد من عدم وجود أخطاء
2. **تسجيل الدخول** - جرب البريد الإلكتروني و Google
3. **إنشاء حساب** - اختبر جميع أنواع الحسابات
4. **الخريطة** - تأكد من ظهور الخريطة والموقع
5. **الصلاحيات** - تأكد من طلب أذونات الموقع والكاميرا

### اختبارات متقدمة
1. **متابعة الحافلات** - تأكد من تحديث الموقع
2. **إبلاغ الغياب** - اختبر النموذج
3. **التنبيهات** - تأكد من عمل الإشعارات
4. **الأدوار المختلفة** - اختبر كل دور مستخدم

## 🔧 حل المشاكل

### خطأ في البناء
```bash
# تنظيف وإعادة بناء
flutter clean
flutter pub get
flutter build apk --debug
```

### خطأ في التثبيت
```bash
# فحص الأجهزة المتصلة
flutter devices

# إعادة تشغيل ADB
adb kill-server
adb start-server
```

### مشكلة في الصلاحيات
- تأكد من إضافة الصلاحيات في AndroidManifest.xml
- تأكد من طلب الصلاحيات في التطبيق
- اختبر على أجهزة مختلفة

## 📊 معلومات APK

### حجم الملف
- **Debug APK**: ~50-80 MB
- **Release APK**: ~30-50 MB

### المتطلبات
- **Android**: 5.0 (API 21) أو أحدث
- **RAM**: 2 GB على الأقل
- **Storage**: 100 MB مساحة فارغة

## 🎯 نصائح للبناء

### لتحسين الأداء
```bash
# بناء مع تحسينات
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### لتصغير الحجم
```bash
# بناء مع تقليل الحجم
flutter build apk --release --split-per-abi
```

## 📱 اختبار على المحاكي

### Android Emulator
```bash
# فتح المحاكي
flutter emulators --launch <emulator_id>

# تشغيل التطبيق
flutter run
```

### اختبار الصلاحيات
- تأكد من عمل أذونات الموقع
- اختبر الكاميرا والمعرض
- تأكد من عمل التنبيهات

## 🚀 النشر

### Google Play Store
1. بناء APK للإنتاج
2. إنشاء حساب مطور
3. رفع APK إلى Play Console
4. ملء معلومات التطبيق
5. مراجعة ونشر

### متاجر أخرى
- **Samsung Galaxy Store**
- **Huawei AppGallery**
- **Amazon Appstore**

## 📞 الدعم

إذا واجهت مشاكل في البناء:
- راجع [وثائق Flutter](https://flutter.dev/docs)
- تحقق من إعدادات Android SDK
- تواصل مع فريق الدعم

---

**تم بناء APK بنجاح! 🎉📱**






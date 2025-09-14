# 🚀 دليل إعداد وتشغيل تطبيق Gold Bus

## 📋 المتطلبات الأساسية

### البرمجيات المطلوبة
- **Flutter SDK 3.7+** - [تحميل من هنا](https://flutter.dev/docs/get-started/install)
- **Dart 3.0+** - يأتي مع Flutter
- **Android Studio** أو **VS Code** - بيئة التطوير
- **Git** - لإدارة الكود

### الحسابات المطلوبة
- **حساب Google** - لـ Firebase و Google Sign-In
- **حساب Firebase** - مجاني من Google

## 🔧 خطوات الإعداد

### 1. إعداد البيئة المحلية

```bash
# تحقق من تثبيت Flutter
flutter doctor

# إذا لم يكن مثبتاً، قم بتثبيته من الموقع الرسمي
# https://flutter.dev/docs/get-started/install
```

### 2. استنساخ المشروع

```bash
# استنساخ المشروع
git clone https://github.com/your-repo/gold-bus.git
cd gold-bus

# تثبيت التبعيات
flutter pub get
```

### 3. إعداد Firebase

#### أ. إنشاء مشروع Firebase
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. انقر على "إضافة مشروع"
3. أدخل اسم المشروع: `gold-bus`
4. اختر المنطقة: `us-central1`
5. انقر "إنشاء المشروع"

#### ب. إضافة تطبيق Android
1. في Firebase Console، انقر على "إضافة تطبيق"
2. اختر Android
3. أدخل Package Name: `com.goldbus.app`
4. انقر "تسجيل التطبيق"
5. حمل ملف `google-services.json`
6. ضع الملف في `android/app/`

#### ج. إضافة تطبيق iOS (اختياري)
1. في Firebase Console، انقر على "إضافة تطبيق"
2. اختر iOS
3. أدخل Bundle ID: `com.goldbus.app`
4. انقر "تسجيل التطبيق"
5. حمل ملف `GoogleService-Info.plist`
6. ضع الملف في `ios/Runner/`

### 4. تفعيل خدمات Firebase

#### أ. Authentication
1. في Firebase Console، اذهب إلى "Authentication"
2. انقر على "بدء الاستخدام"
3. في تبويب "Sign-in method"، فعّل:
   - **Email/Password**
   - **Google** (أضف SHA-1 fingerprint)
   - **Phone** (اختياري)

#### ب. Firestore Database
1. في Firebase Console، اذهب إلى "Firestore Database"
2. انقر على "إنشاء قاعدة بيانات"
3. اختر "بدء في وضع الاختبار"
4. اختر المنطقة: `us-central1`

#### ج. Storage
1. في Firebase Console، اذهب إلى "Storage"
2. انقر على "بدء الاستخدام"
3. اختر "بدء في وضع الاختبار"

### 5. إعداد قواعد الأمان

انسخ والصق هذا الكود في Firestore Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Buses collection
    match /buses/{busId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['driver', 'admin'];
    }
    
    // Students collection
    match /students/{studentId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['supervisor', 'admin'];
    }
    
    // Routes collection
    match /routes/{routeId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['supervisor', 'admin'];
    }
    
    // Absences collection
    match /absences/{absenceId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Notifications collection
    match /notifications/{notificationId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

### 6. إعداد Storage Rules

انسخ والصق هذا الكود في Storage Rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 🚀 تشغيل التطبيق

### على Android
```bash
# تشغيل على جهاز متصل أو محاكي
flutter run

# أو تحديد الجهاز
flutter devices
flutter run -d <device-id>
```

### على iOS (Mac فقط)
```bash
# تشغيل على محاكي iOS
flutter run -d ios

# أو على جهاز iOS متصل
flutter run -d <device-id>
```

### على الويب
```bash
# تشغيل على المتصفح
flutter run -d web
```

## 🧪 اختبار التطبيق

### 1. اختبار التسجيل
1. شغل التطبيق
2. انقر "إنشاء حساب جديد"
3. اختر دور "ولي أمر"
4. أدخل البيانات المطلوبة
5. تأكد من ظهور رسالة النجاح

### 2. اختبار المصادقة
1. سجل دخول بالحساب المنشأ
2. تأكد من ظهور شاشة انتظار الموافقة
3. جرب تسجيل الدخول بـ Google

### 3. اختبار الخرائط
1. انقر "متابعة الحافلات"
2. تأكد من ظهور الخريطة
3. تحقق من تحديد الموقع

## 🔧 استكشاف الأخطاء

### مشاكل شائعة وحلولها

#### خطأ: "Firebase not initialized"
```bash
# تأكد من وجود ملفات الإعداد
ls android/app/google-services.json
ls ios/Runner/GoogleService-Info.plist
```

#### خطأ: "Permission denied"
```bash
# تأكد من قواعد الأمان في Firebase
# تحقق من أن المستخدم مسجل دخول
```

#### خطأ: "Location permission denied"
```bash
# أضف الأذونات في android/app/src/main/AndroidManifest.xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### خطأ: "Google Sign-In failed"
```bash
# تأكد من إضافة SHA-1 fingerprint في Firebase Console
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

## 📱 إعداد الأذونات

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS (ios/Runner/Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>هذا التطبيق يحتاج للموقع لمتابعة الحافلات</string>
<key>NSCameraUsageDescription</key>
<string>هذا التطبيق يحتاج للكاميرا لرفع الصور</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>هذا التطبيق يحتاج لمكتبة الصور لاختيار الصور</string>
```

## 🎯 الخطوات التالية

بعد إعداد التطبيق بنجاح:

1. **إنشاء بيانات تجريبية**
   - أضف حافلات تجريبية
   - أضف طلاب تجريبية
   - أنشئ خطوط سير

2. **اختبار جميع الميزات**
   - تسجيل الدخول والخروج
   - متابعة الحافلات
   - إبلاغ الغياب
   - التنبيهات

3. **النشر**
   - بناء APK للإنتاج
   - رفع التطبيق على Google Play
   - رفع التطبيق على App Store

## 📞 الدعم

إذا واجهت أي مشاكل:
- راجع هذا الدليل مرة أخرى
- تحقق من [وثائق Flutter](https://flutter.dev/docs)
- تحقق من [وثائق Firebase](https://firebase.google.com/docs)
- تواصل مع فريق الدعم: support@goldbus.com

---

**نتمنى لك تجربة تطوير ممتعة! 🚀**






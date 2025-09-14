# 🔥 دليل إعداد Firebase Console لتطبيق Gold Bus

## 📋 الخطوات المطلوبة لإعداد Firebase

### 1. إنشاء مشروع Firebase جديد

1. **اذهب إلى [Firebase Console](https://console.firebase.google.com/)**
2. **اضغط على "إنشاء مشروع" (Create Project)**
3. **أدخل اسم المشروع**: `gold-bus-app`
4. **اختر المنطقة**: `us-central1` (أو أقرب منطقة لك)
5. **اقبل الشروط والأحكام**
6. **اضغط "إنشاء مشروع"**

### 2. إضافة تطبيق Android

1. **في لوحة التحكم، اضغط على أيقونة Android**
2. **أدخل معلومات التطبيق**:
   - **اسم الحزمة**: `com.goldbus.app`
   - **اسم التطبيق**: `Gold Bus`
   - **SHA-1**: (اختياري للآن)
3. **اضغط "تسجيل التطبيق"**
4. **حمل ملف `google-services.json`**
5. **ضع الملف في**: `android/app/google-services.json`

### 3. إضافة تطبيق iOS (اختياري)

1. **اضغط على أيقونة iOS**
2. **أدخل معلومات التطبيق**:
   - **معرف الحزمة**: `com.goldbus.app`
   - **اسم التطبيق**: `Gold Bus`
3. **اضغط "تسجيل التطبيق"**
4. **حمل ملف `GoogleService-Info.plist`**
5. **ضع الملف في**: `ios/Runner/GoogleService-Info.plist`

### 4. تفعيل خدمات Firebase

#### 🔐 Authentication
1. **اذهب إلى "Authentication" في القائمة الجانبية**
2. **اضغط "Get Started"**
3. **اختر علامة التبويب "Sign-in method"**
4. **فعّل الطرق التالية**:
   - ✅ **Email/Password**
   - ✅ **Google** (تتطلب إعداد OAuth)

#### 📊 Firestore Database
1. **اذهب إلى "Firestore Database"**
2. **اضغط "Create database"**
3. **اختر "Start in test mode"** (للاختبار)
4. **اختر المنطقة**: `us-central1`
5. **اضغط "Done"**

#### 🗄️ Storage
1. **اذهب إلى "Storage"**
2. **اضغط "Get started"**
3. **اختر "Start in test mode"**
4. **اختر المنطقة**: `us-central1`
5. **اضغط "Done"**

### 5. إعداد قواعد الأمان

#### قواعد Firestore:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // المستخدمون - يمكن للمستخدم قراءة وكتابة بياناته فقط
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // الطلاب - يمكن للجميع القراءة، المشرفة والإدارة فقط الكتابة
    match /students/{studentId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['supervisor', 'admin'];
    }
    
    // الحافلات - يمكن للجميع القراءة، السائق والإدارة فقط الكتابة
    match /buses/{busId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['driver', 'admin'];
    }
    
    // بلاغات الغياب - يمكن للجميع القراءة، أولياء الأمور والمشرفة والإدارة الكتابة
    match /absences/{absenceId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['parent', 'supervisor', 'admin'];
    }
    
    // الشات - يمكن للمستخدمين المشاركين في المحادثة فقط
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid in resource.data.participants);
    }
    
    // رسائل الشات
    match /chats/{chatId}/messages/{messageId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participants);
    }
  }
}
```

#### قواعد Storage:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // صور الملفات الشخصية
    match /profile_images/{userId}/{fileName} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // صور رخص السائقين
    match /driver_licenses/{userId}/{fileName} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // صور رخص المركبات
    match /vehicle_licenses/{userId}/{fileName} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // صور الحافلات
    match /bus_images/{busId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['driver', 'admin'];
    }
    
    // صور الطلاب
    match /student_images/{studentId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['supervisor', 'admin'];
    }
  }
}
```

### 6. إعداد Google Sign-In

1. **اذهب إلى [Google Cloud Console](https://console.cloud.google.com/)**
2. **اختر مشروع Firebase الخاص بك**
3. **اذهب إلى "APIs & Services" > "Credentials"**
4. **اضغط "Create Credentials" > "OAuth 2.0 Client IDs"**
5. **اختر "Android"**
6. **أدخل معلومات التطبيق**:
   - **اسم**: `Gold Bus Android`
   - **SHA-1**: احصل عليه من Android Studio
   - **معرف الحزمة**: `com.goldbus.app`
7. **اضغط "Create"**
8. **انسخ "Client ID" واستخدمه في التطبيق**

### 7. إعداد Firebase Cloud Messaging (FCM)

1. **اذهب إلى "Cloud Messaging" في Firebase Console**
2. **اضغط "Get Started"**
3. **ستحصل على Server Key تلقائياً**

### 8. تحديث ملفات التطبيق

#### تحديث `android/app/google-services.json`:
- استبدل الملف الموجود بالملف الذي حملته من Firebase Console

#### تحديث `lib/firebase_options.dart`:
- استخدم FlutterFire CLI لتوليد الملف:
```bash
flutter pub global activate flutterfire_cli
flutterfire configure
```

### 9. اختبار الإعداد

1. **شغل التطبيق**: `flutter run`
2. **تأكد من عمل المصادقة**
3. **تأكد من حفظ البيانات في Firestore**
4. **تأكد من رفع الصور إلى Storage**

### 10. نصائح مهمة

- ✅ **احتفظ بنسخة احتياطية من ملفات الإعداد**
- ✅ **لا تشارك مفاتيح API مع أي شخص**
- ✅ **استخدم قواعد أمان صارمة في الإنتاج**
- ✅ **راقب استخدام Firebase في لوحة التحكم**
- ✅ **اضبط حدود الإنفاق لتجنب التكاليف غير المتوقعة**

### 🔧 استكشاف الأخطاء

#### مشاكل شائعة:
1. **خطأ في الاتصال**: تأكد من تحديث ملف `google-services.json`
2. **خطأ في الصلاحيات**: راجع قواعد الأمان
3. **خطأ في Google Sign-In**: تأكد من إعداد OAuth بشكل صحيح
4. **خطأ في رفع الصور**: تأكد من قواعد Storage

#### روابط مفيدة:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)

---

## 🎯 ملخص سريع

1. ✅ إنشاء مشروع Firebase
2. ✅ إضافة تطبيق Android
3. ✅ تفعيل Authentication, Firestore, Storage
4. ✅ إعداد قواعد الأمان
5. ✅ إعداد Google Sign-In
6. ✅ تحديث ملفات التطبيق
7. ✅ اختبار الإعداد

**🚀 بعد اكتمال هذه الخطوات، سيكون تطبيق Gold Bus جاهزاً للعمل مع Firebase!**






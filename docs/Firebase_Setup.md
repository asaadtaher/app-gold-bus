# Firebase Setup Guide

## Prerequisites
- Firebase project created
- Flutter project configured
- Android/iOS apps registered in Firebase Console

## 1. Firebase Project Configuration

### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: "Gold Bus"
4. Enable Google Analytics (recommended)
5. Choose Analytics account

### Enable Required Services
1. **Authentication**
   - Go to Authentication > Sign-in method
   - Enable Email/Password
   - Enable Phone authentication
   - Enable Google Sign-In
   - Enable Facebook Login

2. **Firestore Database**
   - Go to Firestore Database
   - Create database in production mode
   - Set up security rules

3. **Storage**
   - Go to Storage
   - Get started with default rules
   - Configure security rules

4. **Cloud Messaging**
   - Go to Cloud Messaging
   - No additional setup required

5. **Analytics**
   - Go to Analytics
   - Enable Google Analytics

6. **Crashlytics**
   - Go to Crashlytics
   - Enable Crashlytics

## 2. Android Configuration

### Download google-services.json
1. Go to Project Settings > General
2. Under "Your apps", select Android
3. Download `google-services.json`
4. Place in `android/app/` directory

### Update android/app/build.gradle
```gradle
dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.firebase:firebase-firestore'
    implementation 'com.google.firebase:firebase-storage'
    implementation 'com.google.firebase:firebase-messaging'
    implementation 'com.google.firebase:firebase-crashlytics'
}
```

### Update android/build.gradle
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
        classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.9'
    }
}
```

## 3. iOS Configuration

### Download GoogleService-Info.plist
1. Go to Project Settings > General
2. Under "Your apps", select iOS
3. Download `GoogleService-Info.plist`
4. Add to `ios/Runner/` in Xcode

### Update ios/Runner/Info.plist
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

## 4. Environment Variables

Create `.env` file in project root:
```env
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_project.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id
```

## 5. Security Rules

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Bus tracking data - read only for parents
    match /buses/{busId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'driver';
    }
    
    // Student data - parents can read their children's data
    match /students/{studentId} {
      allow read: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.children[studentId] == true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /buses/{busId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'driver';
    }
  }
}
```

## 6. Testing

### Test Authentication
```bash
flutter test test/auth_test.dart
```

### Test Firestore
```bash
flutter test test/firestore_test.dart
```

### Test Push Notifications
1. Send test message from Firebase Console
2. Verify delivery on device
3. Check notification handling

## 7. Troubleshooting

### Common Issues
1. **Build errors**: Check google-services.json placement
2. **Authentication fails**: Verify SHA-1 fingerprints
3. **Firestore permission denied**: Check security rules
4. **Push notifications not working**: Verify FCM setup

### Debug Commands
```bash
flutter clean
flutter pub get
flutter run --debug
```

## 8. Production Deployment

### Android
1. Generate signed APK
2. Upload to Google Play Console
3. Configure Firebase for production

### iOS
1. Archive in Xcode
2. Upload to App Store Connect
3. Configure Firebase for production

## Support

For Firebase-related issues:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- Contact development team


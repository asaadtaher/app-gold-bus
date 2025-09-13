# Gold Bus - School Transportation Management App

A comprehensive Flutter application for managing school transportation with real-time tracking, parent notifications, and administrative features.

## Features

### Core Features
- **Real-time Bus Tracking**: Live location updates with Google Maps integration
- **Parent Notifications**: Check-in/out alerts, speed alerts, and emergency notifications
- **Multi-language Support**: Arabic (RTL) and English (LTR) localization
- **Authentication**: Email, Phone, Google, and Facebook login options
- **Offline Support**: Cached maps and data for offline usage

### Advanced Features
- **SOS Emergency Button**: Quick emergency contact functionality
- **Trip History**: Complete journey logs and reports
- **Multi-child Support**: Parents can track multiple children
- **Geofencing**: Location-based notifications
- **Speed Alerts**: Driver speed monitoring
- **Absence Reporting**: Student attendance tracking

### Admin Features
- **Web Dashboard**: School administrator interface
- **Route Management**: Bus route optimization
- **Student Management**: Comprehensive student database
- **Analytics**: Usage reports and insights
- **Lost & Found**: Item tracking system

## Technical Stack

- **Framework**: Flutter 3.7+
- **State Management**: Riverpod
- **Backend**: Firebase (Auth, Firestore, Storage, FCM, Analytics, Crashlytics)
- **Maps**: Google Maps (Android), Apple MapKit (iOS)
- **Real-time**: WebSocket/MQTT
- **Architecture**: Clean Architecture Pattern

## Project Structure

```
lib/
├── core/                 # Core utilities and constants
├── features/            # Feature-based modules
│   ├── auth/           # Authentication
│   ├── tracking/       # Live tracking
│   ├── notifications/  # Push notifications
│   ├── profile/        # User profile
│   └── admin/          # Admin features
├── shared/             # Shared components
├── assets/             # Images, icons, animations
└── docs/               # Documentation
```

## Setup Instructions

### Prerequisites
- Flutter SDK 3.7+
- Android Studio / Xcode
- Firebase project setup
- Google Maps API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/asaadtaher/app-gold-bus.git
   cd app-gold-bus
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add `google-services.json` (Android) to `android/app/`
   - Add `GoogleService-Info.plist` (iOS) to `ios/Runner/`
   - Update Firebase configuration in `lib/core/firebase/`

4. **Configure Google Maps**
   - Add API key to `android/app/src/main/AndroidManifest.xml`
   - Add API key to `ios/Runner/AppDelegate.swift`

5. **Run the app**
   ```bash
   flutter run
   ```

## Branding

- **Primary Color**: Gold (#FFD700)
- **Secondary Colors**: Black (#000000), Dark Gray (#333333)
- **Typography**: Cairo/Tajawal (Arabic), Roboto (English)
- **Logo**: logo_goldbus.png

## Screen Comparison Matrix

See [docs/Screen_Comparison_Matrix.md](docs/Screen_Comparison_Matrix.md) for detailed feature parity tracking.

## Development

### Testing
- Unit tests: `flutter test`
- Widget tests: `flutter test test/widget_test.dart`
- Integration tests: `flutter test integration_test/`

### Code Quality
- Linting: `flutter analyze`
- Formatting: `dart format .`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is proprietary software. All rights reserved.

## Support

For support and questions, contact the development team.
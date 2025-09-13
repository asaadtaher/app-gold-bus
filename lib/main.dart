import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/localization/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp();

  // ✅ Get FCM Token
  await getFCMToken();

  runApp(
    const ProviderScope(
      child: GoldBusApp(),
    ),
  );
}

// ✅ دالة استخراج التوكين
Future<void> getFCMToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print("🔑 FCM Token: $token");

      // لو عايز تحفظه في Firestore:
      // await FirebaseFirestore.instance.collection('user_tokens').doc('user_id').set({'token': token});
    } else {
      print("⚠️ لم يتم الحصول على التوكين");
    }
  } catch (e) {
    print("❌ خطأ أثناء استخراج التوكين: $e");
  }
}

class GoldBusApp extends ConsumerWidget {
  const GoldBusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'), // Default to Arabic

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Routing
      routerConfig: router,
    );
  }
}
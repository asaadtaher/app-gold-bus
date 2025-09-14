import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

// Notification Service Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// FCM Token Provider
final fcmTokenProvider = FutureProvider<String?>((ref) async {
  final notificationService = ref.watch(notificationServiceProvider);
  return await notificationService.getFCMToken();
});

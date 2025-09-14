import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';

// Firestore Service Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Users Stream Provider
final usersStreamProvider = StreamProvider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.streamUsers();
});

// Students Stream Provider
final studentsStreamProvider = StreamProvider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.streamStudents();
});

// Buses Stream Provider
final busesStreamProvider = StreamProvider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.streamBuses();
});

// Absences Stream Provider
final absencesStreamProvider = StreamProvider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.streamAbsences();
});

// Chat Messages Stream Provider
final chatMessagesStreamProvider = StreamProvider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.streamChatMessages();
});

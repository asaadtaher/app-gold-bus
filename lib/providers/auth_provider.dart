import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.authStateChanges;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// User data provider
final userDataProvider = FutureProvider<UserModel?>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final firestoreService = ref.read(firestoreServiceProvider);
  
  if (currentUser == null) return Future.value(null);
  
  return firestoreService.getUser(currentUser.uid);
});

// User role provider
final userRoleProvider = Provider<UserRole?>((ref) {
  final userData = ref.watch(userDataProvider);
  return userData.when(
    data: (user) => user?.role,
    loading: () => null,
    error: (_, __) => null,
  );
});

// User approval status provider
final userApprovalProvider = Provider<bool?>((ref) {
  final userData = ref.watch(userDataProvider);
  return userData.when(
    data: (user) => user?.approved,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Is user authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser != null;
});

// Is user approved provider
final isUserApprovedProvider = Provider<bool>((ref) {
  final userData = ref.watch(userDataProvider);
  return userData.when(
    data: (user) => user?.approved ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

// Auth controller provider
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref ref;

  AuthController(this.ref);

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authService = ref.read(authServiceProvider);
    return await authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    final authService = ref.read(authServiceProvider);
    return await authService.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      phone: phone,
      role: role,
    );
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    final authService = ref.read(authServiceProvider);
    return await authService.signInWithGoogle();
  }

  // Sign in with phone number
  Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    final authService = ref.read(authServiceProvider);
    return await authService.signInWithPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
    );
  }

  // Verify phone code
  Future<UserCredential?> verifyPhoneCode({
    required String verificationId,
    required String code,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    final authService = ref.read(authServiceProvider);
    return await authService.verifyPhoneCode(
      verificationId: verificationId,
      code: code,
      name: name,
      phone: phone,
      role: role,
    );
  }

  // Update user data
  Future<void> updateUserData(UserModel userModel) async {
    final firestoreService = ref.read(firestoreServiceProvider);
    return await firestoreService.updateUser(userModel.id, userModel.toFirestore());
  }

  // Approve user
  Future<void> approveUser(String userId) async {
    final authService = ref.read(authServiceProvider);
    return await authService.approveUser(userId);
  }

  // Sign out
  Future<void> signOut() async {
    final authService = ref.read(authServiceProvider);
    return await authService.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    final authService = ref.read(authServiceProvider);
    return await authService.resetPassword(email);
  }
}






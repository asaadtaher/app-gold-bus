import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirestoreService _firestoreService = FirestoreService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user model
      final userModel = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        phone: phone,
        role: role,
        approved: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save user to Firestore
      await _firestoreService.addUser(userModel);

      if (kDebugMode) {
        print('✅ User signed up successfully');
      }

      return credential;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error signing up: $e');
      }
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print('✅ User signed in successfully');
      }

      return credential;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error signing in: $e');
      }
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore
      final existingUser = await _firestoreService.getUser(userCredential.user!.uid);
      
      if (existingUser == null) {
        // Create new user
        final userModel = UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: userCredential.user!.displayName ?? '',
          phone: userCredential.user!.phoneNumber ?? '',
          role: UserRole.parent, // Default role
          approved: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestoreService.addUser(userModel);
      }

      if (kDebugMode) {
        print('✅ User signed in with Google successfully');
      }

      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error signing in with Google: $e');
      }
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();

      if (kDebugMode) {
        print('✅ User signed out successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error signing out: $e');
      }
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      if (kDebugMode) {
        print('✅ Password reset email sent');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error sending password reset email: $e');
      }
      rethrow;
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);

      if (kDebugMode) {
        print('✅ Password updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating password: $e');
      }
      rethrow;
    }
  }

  // Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      await currentUser?.verifyBeforeUpdateEmail(newEmail);

      if (kDebugMode) {
        print('✅ Email update verification sent');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating email: $e');
      }
      rethrow;
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();

      if (kDebugMode) {
        print('✅ User account deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting account: $e');
      }
      rethrow;
    }
  }

  // Approve user
  Future<void> approveUser(String userId) async {
    try {
      await _firestoreService.updateUser(userId, {'approved': true});

      if (kDebugMode) {
        print('✅ User approved successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error approving user: $e');
      }
      rethrow;
    }
  }

  // Reject user
  Future<void> rejectUser(String userId) async {
    try {
      await _firestoreService.updateUser(userId, {'approved': false});

      if (kDebugMode) {
        print('✅ User rejected successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error rejecting user: $e');
      }
      rethrow;
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String userId) async {
    try {
      return await _firestoreService.getUser(userId);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting user data: $e');
      }
      return null;
    }
  }

  // Check if user is approved
  Future<bool> isUserApproved(String userId) async {
    try {
      final user = await _firestoreService.getUser(userId);
      return user?.approved ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking user approval: $e');
      }
      return false;
    }
  }
}
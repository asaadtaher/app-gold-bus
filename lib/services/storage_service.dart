import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload profile image
  Future<String> uploadProfileImage(File file, String userId) async {
    try {
      final fileName = 'profile_$userId${path.extension(file.path)}';
      final ref = _storage.ref().child('profile_images/$fileName');
      
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error uploading profile image: $e');
      }
      rethrow;
    }
  }

  // Upload driver license
  Future<String> uploadDriverLicense(File file, String userId) async {
    try {
      final fileName = 'driver_license_$userId${path.extension(file.path)}';
      final ref = _storage.ref().child('driver_licenses/$fileName');
      
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error uploading driver license: $e');
      }
      rethrow;
    }
  }

  // Upload vehicle license
  Future<String> uploadVehicleLicense(File file, String userId) async {
    try {
      final fileName = 'vehicle_license_$userId${path.extension(file.path)}';
      final ref = _storage.ref().child('vehicle_licenses/$fileName');
      
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error uploading vehicle license: $e');
      }
      rethrow;
    }
  }

  // Upload bus image
  Future<String> uploadBusImage(File file, String busId) async {
    try {
      final fileName = 'bus_$busId${path.extension(file.path)}';
      final ref = _storage.ref().child('bus_images/$fileName');
      
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error uploading bus image: $e');
      }
      rethrow;
    }
  }

  // Upload student image
  Future<String> uploadStudentImage(File file, String studentId) async {
    try {
      final fileName = 'student_$studentId${path.extension(file.path)}';
      final ref = _storage.ref().child('student_images/$fileName');
      
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error uploading student image: $e');
      }
      rethrow;
    }
  }

  // Generic file upload
  Future<String> uploadFile(File file, String folderPath) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      final ref = _storage.ref().child('$folderPath/$fileName');
      
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error uploading file: $e');
      }
      rethrow;
    }
  }

  // Delete file
  Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting file: $e');
      }
      rethrow;
    }
  }

  // Get file metadata
  Future<FullMetadata> getFileMetadata(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      return await ref.getMetadata();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting file metadata: $e');
      }
      rethrow;
    }
  }
}
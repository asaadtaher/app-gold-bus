import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/student_model.dart';
import '../models/bus_model.dart';
import '../models/absence_model.dart';
import '../core/constants/app_constants.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users Collection
  Future<void> addUser(UserModel user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .set(user.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding user: $e');
      }
      rethrow;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting user: $e');
      }
      return null;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update(data);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating user: $e');
      }
      rethrow;
    }
  }

  Stream<List<UserModel>> streamUsers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc.data()))
          .toList();
    });
  }

  // Students Collection
  Future<void> addStudent(StudentModel student) async {
    try {
      await _firestore
          .collection(AppConstants.studentsCollection)
          .doc(student.id)
          .set(student.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding student: $e');
      }
      rethrow;
    }
  }

  Future<StudentModel?> getStudent(String studentId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.studentsCollection)
          .doc(studentId)
          .get();
      
      if (doc.exists) {
        return StudentModel.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting student: $e');
      }
      return null;
    }
  }

  Future<void> updateStudentById(String studentId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(AppConstants.studentsCollection)
          .doc(studentId)
          .update(data);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating student: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteStudent(String studentId) async {
    try {
      await _firestore
          .collection(AppConstants.studentsCollection)
          .doc(studentId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting student: $e');
      }
      rethrow;
    }
  }

  Stream<List<StudentModel>> streamStudents() {
    return _firestore
        .collection(AppConstants.studentsCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => StudentModel.fromFirestore(doc.data()))
          .toList();
    });
  }

  // Buses Collection
  Future<void> addBus(BusModel bus) async {
    try {
      await _firestore
          .collection(AppConstants.busesCollection)
          .doc(bus.id)
          .set(bus.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding bus: $e');
      }
      rethrow;
    }
  }

  Future<BusModel?> getBus(String busId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.busesCollection)
          .doc(busId)
          .get();
      
      if (doc.exists) {
        return BusModel.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting bus: $e');
      }
      return null;
    }
  }

  Future<void> updateBus(String busId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(AppConstants.busesCollection)
          .doc(busId)
          .update(data);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating bus: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteBus(String busId) async {
    try {
      await _firestore
          .collection(AppConstants.busesCollection)
          .doc(busId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting bus: $e');
      }
      rethrow;
    }
  }

  Stream<List<BusModel>> streamBuses() {
    return _firestore
        .collection(AppConstants.busesCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BusModel.fromFirestore(doc.data()))
          .toList();
    });
  }

  // Absences Collection
  Future<void> addAbsence(AbsenceModel absence) async {
    try {
      await _firestore
          .collection(AppConstants.absencesCollection)
          .doc(absence.id)
          .set(absence.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding absence: $e');
      }
      rethrow;
    }
  }

  Future<AbsenceModel?> getAbsence(String absenceId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.absencesCollection)
          .doc(absenceId)
          .get();
      
      if (doc.exists) {
        return AbsenceModel.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting absence: $e');
      }
      return null;
    }
  }

  Future<void> updateAbsence(String absenceId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(AppConstants.absencesCollection)
          .doc(absenceId)
          .update(data);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating absence: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteAbsence(String absenceId) async {
    try {
      await _firestore
          .collection(AppConstants.absencesCollection)
          .doc(absenceId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting absence: $e');
      }
      rethrow;
    }
  }

  Stream<List<AbsenceModel>> streamAbsences() {
    return _firestore
        .collection(AppConstants.absencesCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AbsenceModel.fromFirestore(doc.data()))
          .toList();
    });
  }

  // Chat Messages Collection
  Future<void> addChatMessage(Map<String, dynamic> message) async {
    try {
      await _firestore
          .collection(AppConstants.chatMessagesCollection)
          .add(message);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding chat message: $e');
      }
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> streamChatMessages() {
    return _firestore
        .collection(AppConstants.chatMessagesCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {
            'id': doc.id,
            ...doc.data(),
          })
          .toList();
    });
  }

  Future<void> clearChatMessages() async {
    try {
      final batch = _firestore.batch();
      final messages = await _firestore
          .collection(AppConstants.chatMessagesCollection)
          .get();
      
      for (final doc in messages.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error clearing chat messages: $e');
      }
      rethrow;
    }
  }
}
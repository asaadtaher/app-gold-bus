import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

enum AuditEventType {
  userLogin,
  userLogout,
  userRegistration,
  userApproval,
  userRejection,
  studentCreated,
  studentUpdated,
  studentDeleted,
  busCreated,
  busUpdated,
  busDeleted,
  absenceReported,
  absenceApproved,
  absenceRejected,
  locationUpdated,
  messageSent,
  messageReceived,
  fileUploaded,
  fileDeleted,
  settingsChanged,
  dataExported,
  dataImported,
  securityViolation,
  systemError,
  adminAction,
}

class AuditEvent {
  final String id;
  final AuditEventType type;
  final String userId;
  final String? targetUserId;
  final String? targetId;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String? ipAddress;
  final String? userAgent;
  final String? deviceId;
  final String? location;
  final bool isSuccess;
  final String? errorMessage;

  AuditEvent({
    required this.id,
    required this.type,
    required this.userId,
    this.targetUserId,
    this.targetId,
    required this.data,
    required this.timestamp,
    this.ipAddress,
    this.userAgent,
    this.deviceId,
    this.location,
    this.isSuccess = true,
    this.errorMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'userId': userId,
      'targetUserId': targetUserId,
      'targetId': targetId,
      'data': data,
      'timestamp': timestamp,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'deviceId': deviceId,
      'location': location,
      'isSuccess': isSuccess,
      'errorMessage': errorMessage,
    };
  }

  factory AuditEvent.fromMap(Map<String, dynamic> map) {
    return AuditEvent(
      id: map['id'] ?? '',
      type: AuditEventType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AuditEventType.systemError,
      ),
      userId: map['userId'] ?? '',
      targetUserId: map['targetUserId'],
      targetId: map['targetId'],
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      ipAddress: map['ipAddress'],
      userAgent: map['userAgent'],
      deviceId: map['deviceId'],
      location: map['location'],
      isSuccess: map['isSuccess'] ?? true,
      errorMessage: map['errorMessage'],
    );
  }
}

class AuditService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'audit_logs';

  // Log audit event
  static Future<void> logEvent({
    required AuditEventType type,
    required String userId,
    String? targetUserId,
    String? targetId,
    required Map<String, dynamic> data,
    String? ipAddress,
    String? userAgent,
    String? deviceId,
    String? location,
    bool isSuccess = true,
    String? errorMessage,
  }) async {
    try {
      if (!AppConfig.enableLogging) return;

      final event = AuditEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        userId: userId,
        targetUserId: targetUserId,
        targetId: targetId,
        data: data,
        timestamp: DateTime.now(),
        ipAddress: ipAddress,
        userAgent: userAgent,
        deviceId: deviceId,
        location: location,
        isSuccess: isSuccess,
        errorMessage: errorMessage,
      );

      await _firestore
          .collection(_collection)
          .doc(event.id)
          .set(event.toMap());

      if (kDebugMode) {
        print('🔒 Audit Event Logged: ${type.name} - ${event.id}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to log audit event: $e');
      }
    }
  }

  // Log user login
  static Future<void> logUserLogin({
    required String userId,
    required String loginMethod,
    String? ipAddress,
    String? userAgent,
    String? deviceId,
    String? location,
  }) async {
    await logEvent(
      type: AuditEventType.userLogin,
      userId: userId,
      data: {
        'loginMethod': loginMethod,
        'timestamp': DateTime.now().toIso8601String(),
      },
      ipAddress: ipAddress,
      userAgent: userAgent,
      deviceId: deviceId,
      location: location,
    );
  }

  // Log user logout
  static Future<void> logUserLogout({
    required String userId,
    String? ipAddress,
    String? userAgent,
    String? deviceId,
  }) async {
    await logEvent(
      type: AuditEventType.userLogout,
      userId: userId,
      data: {
        'timestamp': DateTime.now().toIso8601String(),
      },
      ipAddress: ipAddress,
      userAgent: userAgent,
      deviceId: deviceId,
    );
  }

  // Log user registration
  static Future<void> logUserRegistration({
    required String userId,
    required String role,
    String? ipAddress,
    String? userAgent,
    String? deviceId,
  }) async {
    await logEvent(
      type: AuditEventType.userRegistration,
      userId: userId,
      data: {
        'role': role,
        'timestamp': DateTime.now().toIso8601String(),
      },
      ipAddress: ipAddress,
      userAgent: userAgent,
      deviceId: deviceId,
    );
  }

  // Log user approval
  static Future<void> logUserApproval({
    required String adminUserId,
    required String targetUserId,
    required String role,
  }) async {
    await logEvent(
      type: AuditEventType.userApproval,
      userId: adminUserId,
      targetUserId: targetUserId,
      data: {
        'role': role,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Log user rejection
  static Future<void> logUserRejection({
    required String adminUserId,
    required String targetUserId,
    required String reason,
  }) async {
    await logEvent(
      type: AuditEventType.userRejection,
      userId: adminUserId,
      targetUserId: targetUserId,
      data: {
        'reason': reason,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Log student creation
  static Future<void> logStudentCreated({
    required String userId,
    required String studentId,
    required String studentName,
  }) async {
    await logEvent(
      type: AuditEventType.studentCreated,
      userId: userId,
      targetId: studentId,
      data: {
        'studentName': studentName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Log student update
  static Future<void> logStudentUpdated({
    required String userId,
    required String studentId,
    required String studentName,
    required Map<String, dynamic> changes,
  }) async {
    await logEvent(
      type: AuditEventType.studentUpdated,
      userId: userId,
      targetId: studentId,
      data: {
        'studentName': studentName,
        'changes': changes,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Log student deletion
  static Future<void> logStudentDeleted({
    required String userId,
    required String studentId,
    required String studentName,
  }) async {
    await logEvent(
      type: AuditEventType.studentDeleted,
      userId: userId,
      targetId: studentId,
      data: {
        'studentName': studentName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Log absence report
  static Future<void> logAbsenceReported({
    required String userId,
    required String studentId,
    required String studentName,
    required String absenceType,
    String? reason,
  }) async {
    await logEvent(
      type: AuditEventType.absenceReported,
      userId: userId,
      targetId: studentId,
      data: {
        'studentName': studentName,
        'absenceType': absenceType,
        'reason': reason,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Log location update
  static Future<void> logLocationUpdated({
    required String userId,
    required String busId,
    required Map<String, double> location,
  }) async {
    await logEvent(
      type: AuditEventType.locationUpdated,
      userId: userId,
      targetId: busId,
      data: {
        'latitude': location['latitude'],
        'longitude': location['longitude'],
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Log message sent
  static Future<void> logMessageSent({
    required String userId,
    required String receiverId,
    required String messageType,
  }) async {
    await logEvent(
      type: AuditEventType.messageSent,
      userId: userId,
      targetUserId: receiverId,
      data: {
        'messageType': messageType,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Log file upload
  static Future<void> logFileUploaded({
    required String userId,
    required String fileName,
    required String fileType,
    required int fileSize,
  }) async {
    await logEvent(
      type: AuditEventType.fileUploaded,
      userId: userId,
      data: {
        'fileName': fileName,
        'fileType': fileType,
        'fileSize': fileSize,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Log security violation
  static Future<void> logSecurityViolation({
    required String userId,
    required String violationType,
    required String description,
    String? ipAddress,
    String? userAgent,
    String? deviceId,
  }) async {
    await logEvent(
      type: AuditEventType.securityViolation,
      userId: userId,
      data: {
        'violationType': violationType,
        'description': description,
        'timestamp': DateTime.now().toIso8601String(),
      },
      ipAddress: ipAddress,
      userAgent: userAgent,
      deviceId: deviceId,
      isSuccess: false,
    );
  }

  // Log system error
  static Future<void> logSystemError({
    required String userId,
    required String errorType,
    required String errorMessage,
    String? stackTrace,
  }) async {
    await logEvent(
      type: AuditEventType.systemError,
      userId: userId,
      data: {
        'errorType': errorType,
        'errorMessage': errorMessage,
        'stackTrace': stackTrace,
        'timestamp': DateTime.now().toIso8601String(),
      },
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }

  // Get audit logs for user
  static Stream<List<AuditEvent>> getUserAuditLogs(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AuditEvent.fromMap(doc.data()))
          .toList();
    });
  }

  // Get audit logs for admin
  static Stream<List<AuditEvent>> getAdminAuditLogs({
    int limit = 100,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: endDate);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AuditEvent.fromMap(doc.data()))
          .toList();
    });
  }

  // Get audit logs by type
  static Stream<List<AuditEvent>> getAuditLogsByType(
    AuditEventType type, {
    int limit = 100,
  }) {
    return _firestore
        .collection(_collection)
        .where('type', isEqualTo: type.name)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AuditEvent.fromMap(doc.data()))
          .toList();
    });
  }

  // Get failed audit logs
  static Stream<List<AuditEvent>> getFailedAuditLogs({int limit = 100}) {
    return _firestore
        .collection(_collection)
        .where('isSuccess', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AuditEvent.fromMap(doc.data()))
          .toList();
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

enum AbsenceType { goingOnly, returningOnly, both }

class AbsenceModel {
  final String id;
  final String studentId;
  final String studentName;
  final String? parentId;
  final String? parentName;
  final AbsenceType type;
  final String reason;
  final DateTime date;
  final DateTime createdAt;
  final String reportedBy; // User ID who reported the absence
  final String reportedByName; // Name of the person who reported
  final bool isApproved;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? notes;

  AbsenceModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    this.parentId,
    this.parentName,
    required this.type,
    required this.reason,
    required this.date,
    required this.createdAt,
    required this.reportedBy,
    required this.reportedByName,
    required this.isApproved,
    this.approvedBy,
    this.approvedAt,
    this.notes,
  });

  factory AbsenceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return AbsenceModel(
      id: doc.id,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      parentId: data['parentId'],
      parentName: data['parentName'],
      type: AbsenceType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => AbsenceType.both,
      ),
      reason: data['reason'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      reportedBy: data['reportedBy'] ?? '',
      reportedByName: data['reportedByName'] ?? '',
      isApproved: data['isApproved'] ?? false,
      approvedBy: data['approvedBy'],
      approvedAt: data['approvedAt'] != null 
          ? (data['approvedAt'] as Timestamp).toDate()
          : null,
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'parentId': parentId,
      'parentName': parentName,
      'type': type.toString().split('.').last,
      'reason': reason,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'reportedBy': reportedBy,
      'reportedByName': reportedByName,
      'isApproved': isApproved,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'notes': notes,
    };
  }

  AbsenceModel copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? parentId,
    String? parentName,
    AbsenceType? type,
    String? reason,
    DateTime? date,
    DateTime? createdAt,
    String? reportedBy,
    String? reportedByName,
    bool? isApproved,
    String? approvedBy,
    DateTime? approvedAt,
    String? notes,
  }) {
    return AbsenceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      parentId: parentId ?? this.parentId,
      parentName: parentName ?? this.parentName,
      type: type ?? this.type,
      reason: reason ?? this.reason,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      reportedBy: reportedBy ?? this.reportedBy,
      reportedByName: reportedByName ?? this.reportedByName,
      isApproved: isApproved ?? this.isApproved,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      notes: notes ?? this.notes,
    );
  }

  String get typeDisplayName {
    switch (type) {
      case AbsenceType.goingOnly:
        return 'ذهاب فقط';
      case AbsenceType.returningOnly:
        return 'عودة فقط';
      case AbsenceType.both:
        return 'ذهاب وعودة';
    }
  }

  @override
  String toString() {
    return 'AbsenceModel(id: $id, studentName: $studentName, type: $typeDisplayName, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AbsenceModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}






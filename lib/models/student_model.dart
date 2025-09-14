import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String id;
  final String name;
  final String address;
  final String grade;
  final String phone;
  final String? parentPhone;
  final String? parentName;
  final String? busId;
  final String? supervisorId;
  final Map<String, double>? location; // {lat: double, lng: double}
  final bool isAbsent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profileImageUrl;
  final String? notes;

  StudentModel({
    required this.id,
    required this.name,
    required this.address,
    required this.grade,
    required this.phone,
    this.parentPhone,
    this.parentName,
    this.busId,
    this.supervisorId,
    this.location,
    required this.isAbsent,
    required this.createdAt,
    required this.updatedAt,
    this.profileImageUrl,
    this.notes,
  });

  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return StudentModel(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      grade: data['grade'] ?? '',
      phone: data['phone'] ?? '',
      parentPhone: data['parentPhone'],
      parentName: data['parentName'],
      busId: data['busId'],
      supervisorId: data['supervisorId'],
      location: data['location'] != null 
          ? Map<String, double>.from(data['location'])
          : null,
      isAbsent: data['isAbsent'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      profileImageUrl: data['profileImageUrl'],
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'grade': grade,
      'phone': phone,
      'parentPhone': parentPhone,
      'parentName': parentName,
      'busId': busId,
      'supervisorId': supervisorId,
      'location': location,
      'isAbsent': isAbsent,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'profileImageUrl': profileImageUrl,
      'notes': notes,
    };
  }

  StudentModel copyWith({
    String? id,
    String? name,
    String? address,
    String? grade,
    String? phone,
    String? parentPhone,
    String? parentName,
    String? busId,
    String? supervisorId,
    Map<String, double>? location,
    bool? isAbsent,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profileImageUrl,
    String? notes,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      grade: grade ?? this.grade,
      phone: phone ?? this.phone,
      parentPhone: parentPhone ?? this.parentPhone,
      parentName: parentName ?? this.parentName,
      busId: busId ?? this.busId,
      supervisorId: supervisorId ?? this.supervisorId,
      location: location ?? this.location,
      isAbsent: isAbsent ?? this.isAbsent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'StudentModel(id: $id, name: $name, grade: $grade, busId: $busId, isAbsent: $isAbsent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}






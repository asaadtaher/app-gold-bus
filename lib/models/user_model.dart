import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { parent, driver, supervisor, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final UserRole role;
  final bool approved;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Driver specific fields
  final String? vehicleType;
  final String? customVehicleType;
  final String? vehicleModel;
  final String? driverLicenseImageUrl;
  final String? vehicleLicenseImageUrl;
  final String? address;
  final String? notes;
  
  // Supervisor specific fields
  final String? schoolName;
  
  // Admin specific fields
  final String? jobTitle;
  final String? organization;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.role,
    required this.approved,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    this.vehicleType,
    this.customVehicleType,
    this.vehicleModel,
    this.driverLicenseImageUrl,
    this.vehicleLicenseImageUrl,
    this.address,
    this.notes,
    this.schoolName,
    this.jobTitle,
    this.organization,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == data['role'],
        orElse: () => UserRole.parent,
      ),
      approved: data['approved'] ?? false,
      location: data['location'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      vehicleType: data['vehicleType'],
      customVehicleType: data['customVehicleType'],
      vehicleModel: data['vehicleModel'],
      driverLicenseImageUrl: data['driverLicenseImageUrl'],
      vehicleLicenseImageUrl: data['vehicleLicenseImageUrl'],
      address: data['address'],
      notes: data['notes'],
      schoolName: data['schoolName'],
      jobTitle: data['jobTitle'],
      organization: data['organization'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'role': role.toString().split('.').last,
      'approved': approved,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'vehicleType': vehicleType,
      'customVehicleType': customVehicleType,
      'vehicleModel': vehicleModel,
      'driverLicenseImageUrl': driverLicenseImageUrl,
      'vehicleLicenseImageUrl': vehicleLicenseImageUrl,
      'address': address,
      'notes': notes,
      'schoolName': schoolName,
      'jobTitle': jobTitle,
      'organization': organization,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    UserRole? role,
    bool? approved,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? vehicleType,
    String? customVehicleType,
    String? vehicleModel,
    String? driverLicenseImageUrl,
    String? vehicleLicenseImageUrl,
    String? address,
    String? notes,
    String? schoolName,
    String? jobTitle,
    String? organization,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      approved: approved ?? this.approved,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      vehicleType: vehicleType ?? this.vehicleType,
      customVehicleType: customVehicleType ?? this.customVehicleType,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      driverLicenseImageUrl: driverLicenseImageUrl ?? this.driverLicenseImageUrl,
      vehicleLicenseImageUrl: vehicleLicenseImageUrl ?? this.vehicleLicenseImageUrl,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      schoolName: schoolName ?? this.schoolName,
      jobTitle: jobTitle ?? this.jobTitle,
      organization: organization ?? this.organization,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role, approved: $approved)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}






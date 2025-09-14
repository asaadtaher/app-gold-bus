import 'package:cloud_firestore/cloud_firestore.dart';

class BusModel {
  final String id;
  final String busNumber;
  final String driverId;
  final String? driverName;
  final String? routeName;
  final List<Map<String, dynamic>> route; // Route coordinates
  final Map<String, double>? currentLocation; // {lat: double, lng: double}
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? busImageUrl;
  final String? notes;
  final List<String> studentIds; // List of student IDs assigned to this bus

  BusModel({
    required this.id,
    required this.busNumber,
    required this.driverId,
    this.driverName,
    this.routeName,
    required this.route,
    this.currentLocation,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.busImageUrl,
    this.notes,
    required this.studentIds,
  });

  factory BusModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return BusModel(
      id: doc.id,
      busNumber: data['busNumber'] ?? '',
      driverId: data['driverId'] ?? '',
      driverName: data['driverName'],
      routeName: data['routeName'],
      route: List<Map<String, dynamic>>.from(data['route'] ?? []),
      currentLocation: data['currentLocation'] != null 
          ? Map<String, double>.from(data['currentLocation'])
          : null,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      busImageUrl: data['busImageUrl'],
      notes: data['notes'],
      studentIds: List<String>.from(data['studentIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'busNumber': busNumber,
      'driverId': driverId,
      'driverName': driverName,
      'routeName': routeName,
      'route': route,
      'currentLocation': currentLocation,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'busImageUrl': busImageUrl,
      'notes': notes,
      'studentIds': studentIds,
    };
  }

  BusModel copyWith({
    String? id,
    String? busNumber,
    String? driverId,
    String? driverName,
    String? routeName,
    List<Map<String, dynamic>>? route,
    Map<String, double>? currentLocation,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? busImageUrl,
    String? notes,
    List<String>? studentIds,
  }) {
    return BusModel(
      id: id ?? this.id,
      busNumber: busNumber ?? this.busNumber,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      routeName: routeName ?? this.routeName,
      route: route ?? this.route,
      currentLocation: currentLocation ?? this.currentLocation,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      busImageUrl: busImageUrl ?? this.busImageUrl,
      notes: notes ?? this.notes,
      studentIds: studentIds ?? this.studentIds,
    );
  }

  @override
  String toString() {
    return 'BusModel(id: $id, busNumber: $busNumber, driverId: $driverId, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BusModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}






import 'package:cloud_firestore/cloud_firestore.dart';

class Route {
  final String id;
  final String name;
  final String description;
  final List<Map<String, double>> stops;
  final String? busId;
  final String? driverId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Route({
    required this.id,
    required this.name,
    required this.description,
    required this.stops,
    this.busId,
    this.driverId,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'stops': stops,
      'busId': busId,
      'driverId': driverId,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Route.fromFirestore(Map<String, dynamic> data) {
    return Route(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      stops: List<Map<String, double>>.from(
        (data['stops'] as List<dynamic>?)?.map((stop) => 
          Map<String, double>.from(stop as Map<String, dynamic>)
        ) ?? []
      ),
      busId: data['busId'],
      driverId: data['driverId'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Route copyWith({
    String? id,
    String? name,
    String? description,
    List<Map<String, double>>? stops,
    String? busId,
    String? driverId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Route(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      stops: stops ?? this.stops,
      busId: busId ?? this.busId,
      driverId: driverId ?? this.driverId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
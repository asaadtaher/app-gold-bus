import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/route.dart';
import '../core/constants/app_constants.dart';

class RouteService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all routes
  Future<List<Route>> getAllRoutes() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.routesCollection)
          .get();
      
      return snapshot.docs
          .map((doc) => Route.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting routes: $e');
      }
      return [];
    }
  }

  // Get route by ID
  Future<Route?> getRouteById(String routeId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.routesCollection)
          .doc(routeId)
          .get();
      
      if (doc.exists) {
        return Route.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting route: $e');
      }
      return null;
    }
  }

  // Add route
  Future<void> addRoute(Route route) async {
    try {
      await _firestore
          .collection(AppConstants.routesCollection)
          .doc(route.id)
          .set(route.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding route: $e');
      }
      rethrow;
    }
  }

  // Update route
  Future<void> updateRoute(String routeId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(AppConstants.routesCollection)
          .doc(routeId)
          .update(data);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating route: $e');
      }
      rethrow;
    }
  }

  // Delete route
  Future<void> deleteRoute(String routeId) async {
    try {
      await _firestore
          .collection(AppConstants.routesCollection)
          .doc(routeId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting route: $e');
      }
      rethrow;
    }
  }

  // Stream routes
  Stream<List<Route>> streamRoutes() {
    return _firestore
        .collection(AppConstants.routesCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Route.fromFirestore(doc.data()))
          .toList();
    });
  }

  // Get routes by bus ID
  Future<List<Route>> getRoutesByBusId(String busId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.routesCollection)
          .where('busId', isEqualTo: busId)
          .get();
      
      return snapshot.docs
          .map((doc) => Route.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting routes by bus ID: $e');
      }
      return [];
    }
  }

  // Get active routes
  Future<List<Route>> getActiveRoutes() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.routesCollection)
          .where('isActive', isEqualTo: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Route.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting active routes: $e');
      }
      return [];
    }
  }
}

// Provider
final routeServiceProvider = Provider<RouteService>((ref) => RouteService());
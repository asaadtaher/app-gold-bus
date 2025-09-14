import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/bus_model.dart';
import '../../../../models/user_model.dart';
import '../../../../services/firestore_service.dart';
import '../../../../services/location_service.dart';
import '../../../../providers/auth_provider.dart';
import '../widgets/bus_marker_widget.dart';
import '../widgets/user_location_widget.dart';

class LiveTrackingPage extends ConsumerStatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  ConsumerState<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends ConsumerState<LiveTrackingPage> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  List<BusModel> _buses = [];
  bool _isLoading = true;
  String? _selectedBusId;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentLocation();
      
      if (position != null) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
        });
      }
      
      await locationService.startLocationTracking();
      
      // Listen to location updates
      locationService.locationStream.listen((position) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
        });
      });
    } catch (e) {
      _showErrorSnackBar('فشل في الحصول على الموقع: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRole = ref.watch(userRoleProvider);
    final userData = ref.watch(userDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تتبع الحافلات المباشر'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerOnUserLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          _buildMap(),
          
          // Loading indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          
          // User info card
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildUserInfoCard(userRole, userData),
          ),
          
          // Bus selection panel
          if (_buses.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildBusSelectionPanel(),
            ),
          
          // Floating action button for absence reporting
          if (userRole == UserRole.parent)
            Positioned(
              bottom: 120,
              right: 16,
              child: _buildAbsenceReportButton(),
            ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return StreamBuilder<List<BusModel>>(
      stream: ref.read(firestoreServiceProvider).streamAllBuses(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _buses = snapshot.data!;
          _isLoading = false;
        }

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _userLocation ?? const LatLng(30.0444, 31.2357), // Cairo
            initialZoom: 13.0,
            minZoom: 5.0,
            maxZoom: 18.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            // OpenStreetMap tiles
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.goldbus.app',
              maxZoom: 18,
            ),
            
            // Bus markers
            MarkerLayer(
              markers: _buildBusMarkers(),
            ),
            
            // User location marker
            if (_userLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _userLocation!,
                    child: const UserLocationWidget(),
                  ),
                ],
              ),
            
            // Route polylines
            PolylineLayer(
              polylines: _buildRoutePolylines(),
            ),
          ],
        );
      },
    );
  }

  List<Marker> _buildBusMarkers() {
    List<Marker> markers = [];
    for (var bus in _buses) {
      if (bus.currentLocation != null) {
        markers.add(
          Marker(
            point: LatLng(
              bus.currentLocation!['lat']!,
              bus.currentLocation!['lng']!,
            ),
            child: BusMarkerWidget(
              bus: bus,
              isSelected: _selectedBusId == bus.id,
              onTap: () => _selectBus(bus.id),
            ),
          ),
        );
      }
    }
    return markers;
  }

  List<Polyline> _buildRoutePolylines() {
    List<Polyline> polylines = [];
    
    for (var bus in _buses) {
      if (bus.route.isNotEmpty) {
        List<LatLng> points = bus.route.map((point) {
          return LatLng(point['lat'], point['lng']);
        }).toList();
        
        polylines.add(
          Polyline(
            points: points,
            strokeWidth: 3.0,
            color: _selectedBusId == bus.id ? Colors.red : Colors.blue,
          ),
        );
      }
    }
    
    return polylines;
  }

  Widget _buildUserInfoCard(UserRole? userRole, AsyncValue<UserModel?> userData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(
                _getRoleIcon(userRole),
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userData.when(
                      data: (user) => user?.name ?? 'غير محدد',
                      loading: () => 'جاري التحميل...',
                      error: (_, __) => 'خطأ في البيانات',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _getRoleDisplayName(userRole),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (userRole == UserRole.parent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'ولي أمر',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusSelectionPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الحافلات المتاحة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _buses.length,
                itemBuilder: (context, index) {
                  final bus = _buses[index];
                  return GestureDetector(
                    onTap: () => _selectBus(bus.id),
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedBusId == bus.id ? Colors.amber : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedBusId == bus.id ? Colors.amber : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.bus,
                            color: _selectedBusId == bus.id ? Colors.black : Colors.grey[600],
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'حافلة ${bus.busNumber}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _selectedBusId == bus.id ? Colors.black : Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            bus.isActive ? 'نشطة' : 'غير نشطة',
                            style: TextStyle(
                              fontSize: 12,
                              color: bus.isActive ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsenceReportButton() {
    return FloatingActionButton.extended(
      onPressed: _showAbsenceReportDialog,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.report_problem, color: Colors.white),
      label: const Text(
        'إبلاغ غياب',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _selectBus(String busId) {
    setState(() {
      _selectedBusId = _selectedBusId == busId ? null : busId;
    });
    
    if (_selectedBusId != null) {
      try {
        final bus = _buses.firstWhere((b) => b.id == busId);
        if (bus.currentLocation != null) {
          _mapController.move(
            LatLng(
              bus.currentLocation!['lat']!,
              bus.currentLocation!['lng']!,
            ),
            15.0,
          );
        }
      } catch (e) {
        print('Bus not found: $e');
      }
    }
  }

  void _centerOnUserLocation() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, 15.0);
    }
  }

  void _refreshData() {
    setState(() {
      _isLoading = true;
    });
    // Data will be refreshed automatically by StreamBuilder
  }

  void _showAbsenceReportDialog() {
    showDialog(
      context: context,
      builder: (context) => const AbsenceReportDialog(),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  IconData _getRoleIcon(UserRole? role) {
    switch (role) {
      case UserRole.parent:
        return FontAwesomeIcons.user;
      case UserRole.driver:
        return FontAwesomeIcons.car;
      case UserRole.supervisor:
        return FontAwesomeIcons.userTie;
      case UserRole.admin:
        return FontAwesomeIcons.userShield;
      default:
        return FontAwesomeIcons.user;
    }
  }

  String _getRoleDisplayName(UserRole? role) {
    switch (role) {
      case UserRole.parent:
        return 'ولي أمر';
      case UserRole.driver:
        return 'سائق';
      case UserRole.supervisor:
        return 'مشرفة';
      case UserRole.admin:
        return 'إدارة';
      default:
        return 'غير محدد';
    }
  }

  @override
  void dispose() {
    ref.read(locationServiceProvider).stopLocationTracking();
    super.dispose();
  }
}

class AbsenceReportDialog extends ConsumerStatefulWidget {
  const AbsenceReportDialog({super.key});

  @override
  ConsumerState<AbsenceReportDialog> createState() => _AbsenceReportDialogState();
}

class _AbsenceReportDialogState extends ConsumerState<AbsenceReportDialog> {
  String _selectedType = 'both'; // 'goingOnly', 'returningOnly', 'both'
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إبلاغ غياب الطالب'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('نوع الغياب:'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedType,
            items: const [
              DropdownMenuItem(
                value: 'goingOnly',
                child: Text('ذهاب فقط'),
              ),
              DropdownMenuItem(
                value: 'returningOnly',
                child: Text('عودة فقط'),
              ),
              DropdownMenuItem(
                value: 'both',
                child: Text('ذهاب وعودة'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: 'سبب الغياب (اختياري)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitAbsenceReport,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('إرسال'),
        ),
      ],
    );
  }

  Future<void> _submitAbsenceReport() async {
    if (_reasonController.text.trim().isEmpty) {
      _reasonController.text = 'لا يوجد سبب محدد';
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Implement absence reporting logic
      // This would involve getting the student ID from the parent's data
      // and creating an absence record in Firestore
      
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال بلاغ الغياب بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في إرسال بلاغ الغياب: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}

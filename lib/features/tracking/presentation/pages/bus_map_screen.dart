import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BusMapScreen extends StatelessWidget {
  const BusMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خريطة الحافلة'),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(30.0444, 31.2357), // موقع الحافلة (القاهرة كمثال)
          zoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.goldbus.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(30.0444, 31.2357),
                width: 40,
                height: 40,
                builder: (ctx) => const Icon(
                  Icons.directions_bus,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
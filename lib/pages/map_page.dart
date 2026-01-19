import 'dart:async';
import 'dart:convert'; // Tambahkan ini
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; // Tambahkan ini

import '../services/location_service.dart';
import '../services/auth_service.dart'; // Pastikan ini ada untuk mengambil baseUrl

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? userLocation;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    try {
      // 1. Ambil posisi GPS HP
      final position = await LocationService.getCurrentPosition();
      userLocation = LatLng(position.latitude, position.longitude);

      // 2. Tambahkan marker lokasi pengguna (Warna Biru)
      _addUserMarker();

      // 3. Ambil data salon ASLI dari Backend Python
      await _fetchRealSalonMarkers(position.latitude, position.longitude);

      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal memuat peta: $e")));
      }
    }
  }

  void _addUserMarker() {
    if (userLocation == null) return;
    _markers.add(
      Marker(
        markerId: const MarkerId("user"),
        position: userLocation!,
        infoWindow: const InfoWindow(title: "Lokasi Anda"),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor
              .hueMagenta, // Pakai hueMagenta (warna pink agak ungu) atau hueRed
        ),
      ),
    );
  }

  // FUNGSI BARU: Mengambil data dari Backend Python Anda
  Future<void> _fetchRealSalonMarkers(double lat, double lng) async {
    try {
      // Pastikan AuthService.baseUrl menggunakan IP Laptop (contoh: http://192.168.1.5:5001/api)
      final url = Uri.parse(
        '${AuthService.baseUrl}/nearby-salons?lat=$lat&lng=$lng',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        for (var salon in data) {
          _markers.add(
            Marker(
              markerId: MarkerId(salon['place_id'] ?? salon['name']),
              position: LatLng(salon['lat'], salon['lng']),
              infoWindow: InfoWindow(
                title: salon['name'],
                snippet: "${salon['address']} | ⭐ ${salon['rating']}",
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor
                    .hueMagenta, // Gunakan hueMagenta untuk warna pink gelap/ungu muda
              ),
            ),
          );
        }
      }
    } catch (e) {
      print("Error fetching salons: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Salon Terdekat"), centerTitle: true),
      body: userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: userLocation!,
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
            ),
    );
  }
}

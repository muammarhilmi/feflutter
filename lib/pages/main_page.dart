import 'package:flutter/material.dart';

import 'upload_page.dart';
import 'map_page.dart';
import 'tips_page.dart';
import 'setting_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _tabIndex = 0;

  Widget _featureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.9),
              color.withOpacity(0.7),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Selamat Datang ",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "Pilih fitur yang ingin Anda gunakan",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          _featureCard(
            context: context,
            icon: Icons.camera_alt,
            title: "Analisis Kuku",
            subtitle: "Scan & deteksi bentuk kuku",
            color: Colors.pink,
            page: const UploadPage(),
          ),
          _featureCard(
            context: context,
            icon: Icons.map,
            title: "Salon Terdekat",
            subtitle: "Cari salon di sekitar Anda",
            color: Colors.teal,
            page: const MapPage(),
          ),
          _featureCard(
            context: context,
            icon: Icons.lightbulb,
            title: "Tips Perawatan",
            subtitle: "Rekomendasi perawatan kuku",
            color: Colors.orange,
            page: const TipsPage(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(_tabIndex == 0 ? "Nail Beauty" : "Pengaturan"),
        centerTitle: true,
      ),
      body: _tabIndex == 0
          ? _homeContent(context)
          : const SettingPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
        selectedItemColor: Colors.pink,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setting",
          ),
        ],
      ),
    );
  }
}

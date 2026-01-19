import 'package:flutter/material.dart';

import 'history_page.dart';
import '../auth/login_page.dart';
import '../services/auth_service.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              AuthService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Pengaturan",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        ListTile(
          leading: const Icon(Icons.history),
          title: const Text("Riwayat Analisis"),
          subtitle: const Text("Lihat hasil analisis sebelumnya"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryPage()),
            );
          },
        ),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text("Logout"),
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }
}

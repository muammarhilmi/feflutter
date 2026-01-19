import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart'; // Pastikan path import ini benar

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> historyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // Fungsi untuk memuat riwayat berdasarkan Email User yang sedang login
  Future<void> _loadHistory() async {
    setState(() => isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Ambil email dari session yang sedang aktif
    final user = await AuthService.getUserSession();
    String email = user['email'] ?? "guest";

    // 2. Gunakan key unik yang menggabungkan email agar tidak tertukar antar akun
    String key = 'nail_history_$email';
    List<String> rawData = prefs.getStringList(key) ?? [];
    
    setState(() {
      // Mengubah string JSON kembali menjadi List Map dan diurutkan dari yang terbaru
      historyList = rawData
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList()
          .reversed
          .toList();
      isLoading = false;
    });
  }

  // Fungsi untuk menghapus riwayat tertentu
  Future<void> _deleteHistory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final user = await AuthService.getUserSession();
    String email = user['email'] ?? "guest";
    String key = 'nail_history_$email';

    List<String> rawData = prefs.getStringList(key) ?? [];
    
    // Karena list di tampilan dibalik (reversed), kita hitung index aslinya di SharedPreferences
    int originalIndex = rawData.length - 1 - index;
    
    // Hapus file gambar dari memori HP agar storage tidak penuh
    try {
      final imagePath = historyList[index]['imagePath'];
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) await file.delete();
      }
    } catch (e) {
      debugPrint("Gagal menghapus file gambar: $e");
    }

    // Hapus data dari list dan simpan kembali
    rawData.removeAt(originalIndex);
    await prefs.setStringList(key, rawData);
    
    // Muat ulang data
    _loadHistory();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Riwayat berhasil dihapus")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Analisis"),
        backgroundColor: Colors.pink[100], // Sesuaikan tema aplikasi
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : historyList.isEmpty
              ? const Center(child: Text("Belum ada riwayat untuk akun ini"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final item = historyList[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (item['imagePath'] != null && File(item['imagePath']).existsSync())
                              ? Image.file(
                                  File(item['imagePath']),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 60, 
                                  height: 60, 
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                        ),
                        title: Text(
                          item['nailArtName'] ?? "Tanpa Nama", 
                          style: const TextStyle(fontWeight: FontWeight.bold)
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("Tanggal: ${item['date']}"),
                            Text(
                              "Hasil: ${item['result'] ?? 'Selesai'}",
                              style: TextStyle(color: Colors.pink[300], fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Hapus Riwayat?"),
                                content: const Text("Data ini akan dihapus permanen."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteHistory(index);
                                    },
                                    child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'segmentation_page.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  Future<void> _pickImage(
    BuildContext context,
    ImageSource source,
  ) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (picked == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SegmentationPage(
          imageFile: File(picked.path),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analisis Kuku"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_camera,
              size: 100,
              color: Colors.pink,
            ),

            const SizedBox(height: 20),

            const Text(
              "Upload Foto Kuku",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Ambil atau pilih foto kuku Anda untuk dianalisis",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // 📸 KAMERA
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Ambil Foto dari Kamera"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.pink,
              ),
              onPressed: () =>
                  _pickImage(context, ImageSource.camera),
            ),

            const SizedBox(height: 12),

            // 🖼️ GALERI
            OutlinedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text("Pilih Foto dari Galeri"),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () =>
                  _pickImage(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}

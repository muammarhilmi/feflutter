import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'recommendation_page.dart';

class ResultPage extends StatelessWidget {
  final String shape;          // OVAL / SQUARE / ALMOND
  final File imageFile;        // FOTO KUKU USER
  final img.Image mask;        // MASK HASIL SEGMENTASI

  const ResultPage({
    super.key,
    required this.shape,
    required this.imageFile,
    required this.mask,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Analisis"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            Text(
              "Bentuk Kuku Anda",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            Text(
              shape,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),

            const Spacer(),

            ElevatedButton.icon(
              icon: const Icon(Icons.brush),
              label: const Text("Lihat Rekomendasi Nail Art"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecommendationPage(
                      shape: shape,
                      imageFile: imageFile,
                      nailMask: mask,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

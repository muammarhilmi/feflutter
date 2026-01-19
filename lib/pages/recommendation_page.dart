import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../data/nail_art_data.dart';
import '../models/nail_art.dart';
import 'layout_page.dart';
import 'upload_page.dart';

class RecommendationPage extends StatelessWidget {
  final String shape;
  final File imageFile;
  final img.Image nailMask;

  const RecommendationPage({
    super.key,
    required this.shape,
    required this.imageFile,
    required this.nailMask,
  });

  @override
  Widget build(BuildContext context) {
    final recommendations = nailArtList
        .where((art) => art.shapes.contains(shape))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Rekomendasi - $shape"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const UploadPage(),
              ),
              (_) => false,
            );
          },
        ),
      ),
      body: recommendations.isEmpty
          ? const Center(
              child: Text(
                "Tidak ada rekomendasi\nuntuk bentuk kuku ini",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final art = recommendations[index];

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.asset(
                          art.image,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              art.event,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              icon:
                                  const Icon(Icons.brush),
                              label: const Text(
                                  "Pasang ke Kuku"),
                              style: ElevatedButton
                                  .styleFrom(
                                minimumSize:
                                    const Size(
                                        double.infinity,
                                        45),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        LayoutPage(
                                      originalImage:
                                          imageFile,
                                      userMask: nailMask,
                                      nailArt: art,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

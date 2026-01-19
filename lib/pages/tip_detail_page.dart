import 'package:flutter/material.dart';
import '../models/tip.dart';

class TipDetailPage extends StatelessWidget {
  final Tip tip;

  const TipDetailPage({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tip.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GAMBAR
            if (tip.imageUrl != null && tip.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  tip.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // JUDUL
            Text(
              tip.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // ISI ARTIKEL FULL
            Text(
              tip.content,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

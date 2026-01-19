import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/nail_art.dart';
import '../services/nail_art_overlay_service.dart';
import '../services/nail_art_mask_service.dart';

class LayoutPage extends StatefulWidget {
  final File originalImage;
  final img.Image userMask;
  final NailArt nailArt;

  const LayoutPage({
    super.key,
    required this.originalImage,
    required this.userMask,
    required this.nailArt,
  });

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  img.Image? result;
  bool loading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _process();
  }

  Future<void> _process() async {
    try {
      final data = await rootBundle.load(widget.nailArt.image);
      final nailArtImage = img.decodeImage(data.buffer.asUint8List())!;
      final nailArtMask = NailArtMaskService.extract(nailArtImage);

      final output = NailArtOverlayService.applyDoubleMask(
        originalImage: widget.originalImage,
        userMask: widget.userMask,
        nailArtImage: nailArtImage,
        nailArtMask: nailArtMask,
      );

      setState(() {
        result = output;
        loading = false;
      });
    } catch (e) {
      debugPrint("Layout error: $e");
      setState(() => loading = false);
    }
  }

  Future<void> _saveToHistory() async {
    if (result == null) return;
    setState(() => isSaving = true);

    try {
      // 1. Simpan gambar fisik ke folder dokumen HP
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = "nail_${DateTime.now().millisecondsSinceEpoch}.png";
      final File imageFile = File('${directory.path}/$fileName');
      await imageFile.writeAsBytes(img.encodePng(result!));

      // 2. Simpan metadata ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      List<String> historyRaw = prefs.getStringList('nail_history') ?? [];

      Map<String, dynamic> newItem = {
        'imagePath': imageFile.path,
        'nailArtName': "Desain ${widget.nailArt.event}", // Menggunakan .event karena .name tidak ada di modelmu
        'date': DateTime.now().toString().split('.')[0],
      };

      historyRaw.add(jsonEncode(newItem));
      await prefs.setStringList('nail_history', historyRaw);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil disimpan ke Riwayat!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      debugPrint("Save error: $e");
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Nail Art")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: result == null 
                    ? const Center(child: Text("Gagal proses")) 
                    : Image.memory(Uint8List.fromList(img.encodePng(result!))),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: isSaving ? null : _saveToHistory,
                    icon: isSaving ? const CircularProgressIndicator() : const Icon(Icons.save),
                    label: Text(isSaving ? "Menyimpan..." : "Simpan Hasil"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50)
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
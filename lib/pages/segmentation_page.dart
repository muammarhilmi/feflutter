import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../services/tflite_service.dart';
import '../services/nail_shape_rule.dart';
import 'result_page.dart';

class SegmentationPage extends StatefulWidget {
  final File imageFile;

  const SegmentationPage({
    super.key,
    required this.imageFile,
  });

  @override
  State<SegmentationPage> createState() => _SegmentationPageState();
}

class _SegmentationPageState extends State<SegmentationPage> {
  @override
  void initState() {
    super.initState();
    process();
  }

  Future<void> process() async {
    try {
      // 1️⃣ SEGMENTASI KUKU (TFLite)
      final img.Image nailMask =
          await TFLiteService.segment(widget.imageFile);

      // 2️⃣ KLASIFIKASI BENTUK KUKU (RULE-BASED)
      final String shape =
          NailShapeRule.classify(nailMask);

      // 3️⃣ PINDAH KE RESULT PAGE (DATA LENGKAP)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            shape: shape,
            imageFile: widget.imageFile,
            mask: nailMask,
          ),
        ),
      );
    } catch (e) {
      // ERROR HANDLING
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal analisis: $e")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

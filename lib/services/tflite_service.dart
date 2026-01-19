import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  static Interpreter? _interpreter;

  static Future<void> loadModel() async {
    if (_interpreter != null) return;

    _interpreter = await Interpreter.fromAsset(
      'assets/models/nail_seg_fp16.tflite',
      options: InterpreterOptions()..threads = 4,
    );
  }

  static Future<img.Image> segment(File imageFile) async {
    await loadModel();

    /// 1️⃣ Decode original image
    final raw = imageFile.readAsBytesSync();
    final original = img.decodeImage(raw)!;

    /// 2️⃣ Resize for model input
    final resized = img.copyResize(
      original,
      width: 256,
      height: 256,
      interpolation: img.Interpolation.linear,
    );

    /// 3️⃣ INPUT [1,256,256,3]
    final input = List.generate(
      1,
      (_) => List.generate(
        256,
        (y) => List.generate(
          256,
          (x) {
            final p = resized.getPixel(x, y);
            return [
              p.r / 255.0,
              p.g / 255.0,
              p.b / 255.0,
            ];
          },
        ),
      ),
    );

    /// 4️⃣ OUTPUT [1,256,256,1]
    final output = List.generate(
      1,
      (_) => List.generate(
        256,
        (_) => List.generate(
          256,
          (_) => List.filled(1, 0.0),
        ),
      ),
    );

    /// 5️⃣ Run inference
    _interpreter!.run(input, output);

    /// 6️⃣ Convert to binary mask (256x256)
    final smallMask = img.Image(
      width: 256,
      height: 256,
    );

    for (int y = 0; y < 256; y++) {
      for (int x = 0; x < 256; x++) {
        final v = output[0][y][x][0];
        final c = v > 0.3 ? 255 : 0; // ⚠️ threshold lebih aman
        smallMask.setPixelRgb(x, y, c, c, c);
      }
    }

    /// 7️⃣ 🔥 RESIZE MASK KE UKURAN ASLI (INI KUNCI)
    final fullMask = img.copyResize(
      smallMask,
      width: original.width,
      height: original.height,
      interpolation: img.Interpolation.nearest,
    );

    return fullMask;
  }
}

import 'dart:io';
import 'package:image/image.dart' as img;

class NailArtOverlayService {
  static img.Image applyDoubleMask({
    required File originalImage,
    required img.Image userMask,
    required img.Image nailArtImage,
    required img.Image nailArtMask,
  }) {
    // Decode original image
    img.Image base =
        img.decodeImage(originalImage.readAsBytesSync())!;

    // Samakan ukuran dengan mask user
    base = img.copyResize(
      base,
      width: userMask.width,
      height: userMask.height,
    );

    /// 1️⃣ Cari bounding box kuku USER
    int minX = userMask.width, minY = userMask.height;
    int maxX = 0, maxY = 0;

    for (int y = 0; y < userMask.height; y++) {
      for (int x = 0; x < userMask.width; x++) {
        if (userMask.getPixel(x, y).r > 128) {
          if (x < minX) minX = x;
          if (y < minY) minY = y;
          if (x > maxX) maxX = x;
          if (y > maxY) maxY = y;
        }
      }
    }

    if (minX >= maxX || minY >= maxY) return base;

    final width = maxX - minX;
    final height = maxY - minY;

    /// 2️⃣ Resize nail art & mask ke area kuku
    final resizedArt = img.copyResize(
      nailArtImage,
      width: width,
      height: height,
    );

    final resizedMask = img.copyResize(
      nailArtMask,
      width: width,
      height: height,
    );

    /// ✨ 3️⃣ BLUR RINGAN PADA MASK (EDGE SOFTENING)
    final smoothMask = img.gaussianBlur(
    resizedMask,
    radius: 1,
);
    // radius 1 = ringan, aman, tidak bocor

    final result = img.Image.from(base);

    /// 4️⃣ Overlay hanya pixel nail art + di dalam kuku user
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final artMaskPixel = smoothMask.getPixel(x, y).r;
        final userMaskPixel =
            userMask.getPixel(minX + x, minY + y).r;

        if (artMaskPixel > 100 && userMaskPixel > 128) {
          result.setPixel(
            minX + x,
            minY + y,
            resizedArt.getPixel(x, y),
          );
        }
      }
    }

    return result;
  }
}

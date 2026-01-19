import 'package:image/image.dart' as img;

class NailArtMaskService {
  /// Membuat mask dari nail art e-commerce
  /// Menganggap background PUTIH / TERANG
  static img.Image extract(img.Image art) {
    final mask = img.Image(
      width: art.width,
      height: art.height,
    );

    for (int y = 0; y < art.height; y++) {
      for (int x = 0; x < art.width; x++) {
        final p = art.getPixel(x, y);

        /// Background biasanya terang (putih)
        final isBackground =
            p.r > 230 && p.g > 230 && p.b > 230;

        final c = isBackground ? 0 : 255;
        mask.setPixelRgb(x, y, c, c, c);
      }
    }

    /// Haluskan tepi
    return img.gaussianBlur(mask, radius: 1);
  }
}

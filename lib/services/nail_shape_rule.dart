import 'package:image/image.dart' as img;

class NailShapeRule {
  static String classify(img.Image mask) {
    int minX = mask.width, maxX = 0;
    int minY = mask.height, maxY = 0;

    for (int y = 0; y < mask.height; y++) {
      for (int x = 0; x < mask.width; x++) {
        if (mask.getPixel(x, y).r > 0) {
          minX = x < minX ? x : minX;
          maxX = x > maxX ? x : maxX;
          minY = y < minY ? y : minY;
          maxY = y > maxY ? y : maxY;
        }
      }
    }

    final width = maxX - minX;
    final height = maxY - minY;
    final ratio = width / height;

    if (ratio > 0.85 && ratio < 1.15) return "OVAL";
    if (ratio <= 0.85) return "ALMOND";
    return "SQUARE";
  }
}

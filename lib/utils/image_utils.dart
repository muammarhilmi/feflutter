import 'package:image/image.dart' as img;

img.Image overlayNailArt(
  img.Image original,
  img.Image mask,
  img.Image nailArt,
) {
  for (int y = 0; y < original.height; y++) {
    for (int x = 0; x < original.width; x++) {
      if (mask.getPixel(x, y).r > 0) {
        var artPixel = nailArt.getPixel(x, y);
        original.setPixel(x, y, artPixel);
      }
    }
  }
  return original;
}

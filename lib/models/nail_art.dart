class NailArt {
  /// Path asset gambar nail art
  final String image;

  /// Cocok untuk acara apa
  final String event;

  /// Link ecommerce (opsional)
  final String ecommerce;

  /// Bentuk kuku yang cocok (OVAL, SQUARE, ALMOND)
  final List<String> shapes;

  const NailArt({
    required this.image,
    required this.event,
    required this.ecommerce,
    required this.shapes,
  });
}

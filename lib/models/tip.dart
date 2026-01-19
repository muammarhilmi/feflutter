class Tip {
  final int id;
  final String title;
  final String content;
  final String? imageUrl;

  Tip({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
    );
  }
}

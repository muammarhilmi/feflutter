class HistoryItem {
  final String imagePath;
  final String nailArtName;
  final String date;

  HistoryItem({required this.imagePath, required this.nailArtName, required this.date});

  // Untuk mengubah data ke teks (JSON) agar bisa disimpan di SharedPrefs
  Map<String, dynamic> toMap() => {
    'imagePath': imagePath,
    'nailArtName': nailArtName,
    'date': date,
  };

  factory HistoryItem.fromMap(Map<String, dynamic> map) => HistoryItem(
    imagePath: map['imagePath'],
    nailArtName: map['nailArtName'],
    date: map['date'],
  );
}
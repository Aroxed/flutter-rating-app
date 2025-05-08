class ImageItem {
  final int id;
  final String filename;
  int rating;
  final DateTime createdAt;

  ImageItem({
    required this.id,
    required this.filename,
    this.rating = 0,
    required this.createdAt,
  });

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      id: json['id'] as int,
      filename: json['filename'] as String,
      rating: json['rating'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }
} 
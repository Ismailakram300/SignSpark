class Concept {
  final int id;
  final String title;
  final String titleSecondary;
  final String image;
  final String difficulty;

  Concept({
    required this.id,
    required this.title,
    required this.titleSecondary,
    required this.image,
    required this.difficulty,
  });

  factory Concept.fromJson(Map<String, dynamic> json) {
    return Concept(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      titleSecondary: json['title_secondary'] ?? '',
      image: json['image'] ?? '',
      difficulty: json['difficulty'] ?? '',
    );
  }
}
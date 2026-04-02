class ConceptDetail {
  final int id;
  final String title;
  final String titleSecondary;
  final String image;
  final String difficulty;

  ConceptDetail({
    required this.id,
    required this.title,
    required this.titleSecondary,
    required this.image,
    required this.difficulty,
  });

  
  factory ConceptDetail.fromJson(Map<String, dynamic> json) {
    return ConceptDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      titleSecondary: json['title_secondary'] ?? '',
      image: json['image'] ?? '',
      difficulty: json['difficulty'] ?? '',
    );
  }
}

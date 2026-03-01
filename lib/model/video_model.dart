class VideoModel {
  final int id;
  final String title;
  final String titleSecondary;
  final String videoUrl;
  final String thumbnail;

  final NestedItem? location;
  final NestedItem? movement;
  final NestedItem? secondMovement;
  final NestedItem? dominantShape;
  final NestedItem? nonDominantShape;

  VideoModel({
    required this.id,
    required this.title,
    required this.titleSecondary,
    required this.videoUrl,
    required this.thumbnail,
    this.location,
    this.movement,
    this.secondMovement,
    this.dominantShape,
    this.nonDominantShape,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      titleSecondary: json['title_secondary'] ?? '',
      videoUrl: json['video_url'] ?? '',
      thumbnail: json['thumbnail'] ?? '',

      location: json['location'] != null
          ? NestedItem.fromJson(json['location'])
          : null,

      movement: json['movement'] != null
          ? NestedItem.fromJson(json['movement'])
          : null,

      secondMovement: json['second_movement'] != null
          ? NestedItem.fromJson(json['second_movement'])
          : null,

      dominantShape: json['dominant_shape'] != null
          ? NestedItem.fromJson(json['dominant_shape'])
          : null,

      nonDominantShape: json['non_dominant_shape'] != null
          ? NestedItem.fromJson(json['non_dominant_shape'])
          : null,
    );
  }
}
class NestedItem {
  final int id;
  final String title;
  final String? titleSecondary;
  final String image;

  NestedItem({
    required this.id,
    required this.title,
    this.titleSecondary,
    required this.image,
  });

  factory NestedItem.fromJson(Map<String, dynamic> json) {
    return NestedItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      titleSecondary: json['title_secondary'],
      image: json['image'] ?? '',
    );
  }
}
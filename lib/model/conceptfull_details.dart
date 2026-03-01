import 'package:sign_spark/model/video_model.dart';

import 'category_model_psl.dart';
import 'concept_details.dart';

class ConceptFullDetail {
  final Category category;
  final ConceptDetail concept;
  final List<VideoModel> videos;

  ConceptFullDetail({
    required this.category,
    required this.concept,
    required this.videos,
  });

  factory ConceptFullDetail.fromJson(Map<String, dynamic> json) {
    return ConceptFullDetail(
      category: Category.fromJson(json['category']),
      concept: ConceptDetail.fromJson(json['concept']),
      videos: (json['videos'] as List)
          .map((e) => VideoModel.fromJson(e))
          .toList(),
    );
  }
}
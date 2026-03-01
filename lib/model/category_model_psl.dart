import 'package:sign_spark/model/psl_concept_model.dart';

class Category {
  final int id;
  final String slug;
  final String title;
  final String titleSecondary;
  final String storageSlug;
  final String image;
  final int status;
  final int enableIsharay;
  final int order;
  final int createdBy;
  final int updatedby;

  Category({
    required this.id,
    required this.slug,
    required this.title,
    required this.titleSecondary,
    required this.storageSlug,
    required this.image,
    required this.status,
    required this.enableIsharay,
    required this.order,
    required this.createdBy,
    required this.updatedby,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      titleSecondary: json['title_secondary'] ?? '',
      storageSlug: json['storage_slug'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? 0,
      enableIsharay: json['enable_isharay'] ?? 0,
      order: json['order'] ?? 0,
      createdBy: json['created_by'] ?? 0,
      updatedby: json['updated_by'],
    );
  }
}
class CategoryDetail {
  final Category category;
  final List<Concept> concepts;

  CategoryDetail({
    required this.category,
    required this.concepts,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) {
    return CategoryDetail(
      category: Category.fromJson(json['category']),
      concepts: (json['concepts'] as List)
          .map((e) => Concept.fromJson(e))
          .toList(),
    );
  }
}
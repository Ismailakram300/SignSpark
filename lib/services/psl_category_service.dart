import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/category_model_psl.dart';
import '../model/conceptfull_details.dart';

class PslApiService{
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse("https://admin.psl.org.pk/api/category"));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List data = decoded['data'];

      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
  Future<CategoryDetail> fetchCategoryDetail(int categoryId) async {
    final response = await http.get(
      Uri.parse("https://admin.psl.org.pk/api/category/$categoryId"),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      return CategoryDetail.fromJson(decoded['data']);
    } else {
      throw Exception("Failed to load category detail");
    }
  }
  Future<ConceptFullDetail> fetchConceptDetail(int id) async {
    final response = await http.get(
      Uri.parse("https://admin.psl.org.pk/api/concept/$id/videos"),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return ConceptFullDetail.fromJson(decoded['data']);
    } else {
      throw Exception("Failed to load detail");
    }
  }
}
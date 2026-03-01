import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_spark/services/psl_category_service.dart';
import 'package:sign_spark/view/psl_cateory_detail_screen.dart';

import '../model/category_model_psl.dart';
import '../widgets/image_builder.dart';

class CategoryScreen extends StatelessWidget {
  final PslApiService apiService= PslApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pakistan Sign Language")),
      body: FutureBuilder<List<Category>>(
        future: apiService.fetchCategories(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final categories = snapshot.data!;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryDetailScreen(
                          categoryId: category.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          /// 🔥 Image
                          SmartNetworkImage(
                            imageUrl: category.image,
                            width: 60,
                            height: 60,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          const SizedBox(width: 16),

                          /// 🔥 Text Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category.titleSecondary,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// 🔥 Arrow Icon
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
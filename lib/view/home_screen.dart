import 'package:flutter/material.dart';
import 'package:sign_spark/Quiz/quiz.dart';
import 'package:sign_spark/activities.dart';
import 'package:sign_spark/aplhabet_signs/aplhabetic_ui.dart';
import 'package:sign_spark/view/psl_category_list_screen.dart';
import 'package:sign_spark/view/psl_cateory_detail_screen.dart';

import '../Quiz/phrase_quiz.dart';
import '../camera/camera_prediction.dart';
import '../camera/live_camera.dart';
import '../model/category_model_psl.dart';
import '../random_words/random_words_ui.dart';
import '../services/psl_category_service.dart';
import '../widgets/image_builder.dart';
import 'Camera.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dashboardItems = [
    {"title": "Users", "icon": Icons.people, "color": Colors.blue},
    {"title": "Orders", "icon": Icons.shopping_cart, "color": Colors.green},
    {"title": "Reports", "icon": Icons.bar_chart, "color": Colors.orange},
    {"title": "Settings", "icon": Icons.settings, "color": Colors.purple},
    {"title": "Messages", "icon": Icons.message, "color": Colors.red},
    {"title": "Tracking", "icon": Icons.location_on, "color": Colors.teal},
  ];
  final PslApiService apiService = PslApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // Progress Bar
          // SizedBox(height: 10),
          // Container(
          //   height: 140,
          //   width: double.infinity,
          //   child: GridView.count(
          //     crossAxisCount: 3,
          //     padding: EdgeInsets.all(16),
          //     crossAxisSpacing: 16,
          //     mainAxisSpacing: 16,
          //     children: [
          //       DashboardTile(
          //         icon: Icons.sign_language,
          //         label: "English Alphabet",
          //         ontap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (_) => AplhabeticUi()),
          //           );
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pakistan Sign language (PSL)",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CategoryScreen()),
                    );
                  },
                  child: Text(
                    "more",
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Category>>(
            future: apiService.fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final categories = snapshot.data!;
              final allowedNames = [
               // "English Alphabet",
                "Urdu Alphabet",
                "Adverbs",
                "Adjectives",
                "Airport",
                "Appliances",
                "Arts",
                "Birds",
                "Body Anatomy",
                "Clothes and Accessories",
                "Government",
                "Nouns - General",
                "Numbers",
                "Pakistan Places",
                "Pronouns",
                "Science",
                "Sentences",
                "Transport",
                "Verbs",
                "Weather",
                "Sports and Games",
              ];

              final filteredCategories = categories
                  .where((c) => allowedNames.contains(c.title))
                  .toList();
              filteredCategories.insert(
                0,
                Category(
                  id: -1,
                  title: "English Alphabet",
                  titleSecondary: "A B C",
                  image:  "https://d18qapjg363q5r.cloudfront.net/public/categories/abc-two-handed.png",
                  slug: '',
                  storageSlug: '',
                  status:0,
                  enableIsharay: 0,
                  order: 0,
                  createdBy: 0,
                  updatedby: 0,
                ),
              );
              DashboardTile(
                icon: Icons.sign_language,
                label: "English Alphabet",
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AplhabeticUi()),
                  );
                },
              );
              return SizedBox(
                height: 250, // 🔥 Important: define height for horizontal grid
                width: 370,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 🔥 2 rows
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2, // adjust UI ratio
                  ),
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // 🔥 Get card width dynamically
                        double cardWidth = constraints.maxWidth;

                        // 🔥 Image size = 35% of card width
                        double imageSize = cardWidth * 0.35;

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            if (category.id == -1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => AplhabeticUi()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategoryDetailScreen(
                                    categoryId: category.id,
                                  ),
                                ),
                              );
                            }
                          },
                          // onTap: () {
                          //
                          //   // Navigator.push(
                          //   //   context,
                          //   //   MaterialPageRoute(
                          //   //     builder: (_) => CategoryDetailScreen(
                          //   //       categoryId: category.id,
                          //   //     ),
                          //   //   ),
                          //   // );
                          // },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// 🔥 Responsive Image
                                SmartNetworkImage(
                                  imageUrl: category.image,
                                  width: imageSize,
                                  height: imageSize,
                                  borderRadius: BorderRadius.circular(
                                    imageSize * 0.2,
                                  ),
                                ),

                                SizedBox(height: imageSize * 0.25),

                                /// 🔥 Title
                                Text(
                                  category.title,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        cardWidth * 0.09, // responsive text
                                  ),
                                ),

                                SizedBox(height: cardWidth * 0.03),

                                /// 🔥 Subtitle
                                Text(
                                  category.titleSecondary,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: cardWidth * 0.075,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
          // Dashboard Grid
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Other Learning Activities",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CategoryScreen()),
                    );
                  },
                  child: Text(
                    "",
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                // DashboardTile(
                //   icon: Icons.sign_language,
                //   label: "English Alphabet",
                //   ontap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (_) => AplhabeticUi()),
                //     );
                //   },
                // ),
                DashboardTile(
                  icon: Icons.extension,
                  label: "Activities",
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Activities()),
                    );
                  },
                ),
                DashboardTile(
                  icon: Icons.quiz,
                  label: "Quick Quiz",
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Quiz()),
                    );
                  },
                ),
                DashboardTile(
                  icon: Icons.video_library,
                  label: "Videos",
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RandomWordsUi()),
                    );
                  },
                ),
                DashboardTile(
                  icon: Icons.question_mark,
                  label: "Random Quiz",
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PhraseQuiz()),
                    );
                  },
                ),
                DashboardTile(
                  icon: Icons.camera,
                  label: "Camera",
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LiveTest()),
                    );
                  },
                ),
                // DashboardTile(
                //   icon: Icons.emoji_events,
                //   label: "Camera",
                //   ontap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (_) => SignPredictionScreen()),
                //     );
                //   },
                // ),
                // DashboardTile(
                //   icon: Icons.emoji_events,
                //   label: "Psl",
                //   ontap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (_) => CategoryScreen()),
                //     );
                //   },
                // ),
              ],
            ),
          ),

          // Mascot Banner
          // Container(
          //   height: 90,
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   decoration: BoxDecoration(
          //     color: Colors.blue.shade50,
          //     borderRadius: BorderRadius.circular(18),
          //   ),
          //   child: Row(
          //     children: [
          //       Image.asset("assets/images/logo.png", height: 70),
          //       SizedBox(width: 16),
          //       Expanded(
          //         child: Text(
          //           "Great job today! Keep learning! 👏",
          //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(.2),
              radius: 28,
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback ontap;
  DashboardTile({required this.icon, required this.label, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // shadow color
            blurRadius: 8, // how soft the shadow is
            spreadRadius: 2, // how much the shadow spreads
            offset: Offset(0, 4), // x and y offset
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: ontap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 35, color: Colors.green.shade600),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

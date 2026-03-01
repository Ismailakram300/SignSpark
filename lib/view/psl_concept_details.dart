import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sign_spark/services/psl_category_service.dart';


import '../model/category_model_psl.dart';


import '../model/conceptfull_details.dart';
import '../widgets/custom_card.dart';
import '../widgets/video_player.dart';

class ConceptDetailScreen extends StatefulWidget {
  final int conceptId;
  const ConceptDetailScreen({super.key, required this.conceptId});

  @override
  State<ConceptDetailScreen> createState() => _ConceptDetailScreenState();
}

class _ConceptDetailScreenState extends State<ConceptDetailScreen> {

  int selectedIndex = 0;

  @override
  final PslApiService apiService = PslApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Category Detail")),
      body: FutureBuilder<ConceptFullDetail>(
        future: apiService.fetchConceptDetail(widget.conceptId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error"));
          }

          final data = snapshot.data!;
          final videos = data.videos;
          final video = videos[selectedIndex];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                children: [

                  // 🔹 Concept Info
                  // Image.network(
                  //   "https://d18qapjg363q5r.cloudfront.net/public/${data.concept.image}",
                  // ),

                //  Text(data.concept.difficulty),

                  Column(
                    children: [

                      NetworkVideoPlayer(
                        videoUrl: video.videoUrl,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration:BoxDecoration(
                          color: Colors.grey.shade100,borderRadius: BorderRadius.circular(10)
                        ),
                      
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(data.concept.title,style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21
                                ),),
                              ),
                              SizedBox(
                                height: 18, // card ke approx height ke barabar
                                child: VerticalDivider(
                                  thickness: 1,
                                  width: 20,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(data.concept.titleSecondary,style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21
                                ),),
                              ),

                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// 🔹 Selected Video Data
                      ///
                      Container(
                        height: 180,
                        decoration: BoxDecoration(

                        ),
                        child: Row(
                          children: [
                            if (video.location != null)
                            Expanded(
                              child: SmartInfoCard(
                                title: "Location",
                                value: video.location?.title ?? "No Location",
                                imageUrl: video.location?.image,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (video.movement != null)
                            Expanded(
                              child: SmartInfoCard(
                                title: "Movement",
                                value: video.movement?.title ?? "No Movement",
                                imageUrl: video.movement?.image,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (video.dominantShape != null)
                            Expanded(
                              child: SmartInfoCard(
                                title: "Shape",
                                value: video.dominantShape?.title ?? "No Shape",
                                imageUrl: video.dominantShape?.image,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      /// 🔹 SIGN BUTTONS
                      if (videos.length != 1)
                      SizedBox(
                        height: 45,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            final isSelected = selectedIndex == index;

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    isSelected ? Colors.green : Colors.grey.shade300,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Text(
                                    "Sign ${index + 1}",
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),



                      /// 🔹 Thumbnail + Title

                    ],
                  ),
                  // 🔹 Videos List
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemCount: data.videos.length,
                  //   itemBuilder: (context, index) {
                  //     final video = data.videos[index];
                  //
                  //
                  //     return Row(
                  //       children: [
                  //         Expanded(
                  //           child: SmartInfoCard(
                  //             title: "Location",
                  //             value: "Space",
                  //             imageUrl: video.location?.image,
                  //           ),
                  //         ),
                  //         SizedBox(height: 10,),
                  //       //  Text(video.location?.title ?? "No Location"),
                  //       //   SvgPicture.network(
                  //       //     video.location?.image ?? '',
                  //       //     width: 40,
                  //       //     height: 40,
                  //       //   ),
                  //         Expanded(
                  //           child: SmartInfoCard(
                  //             title: "Movement",
                  //             value: video.movement?.title ?? "No Movement",
                  //             imageUrl: video.movement?.image,
                  //           ),
                  //         ),
                  //         SizedBox(height: 10,),
                  //        // Text(video.movement?.title ?? "No Movement"),
                  //         Expanded(
                  //           child: SmartInfoCard(
                  //             title: "Shape",
                  //             value: video.dominantShape?.title ?? "No Movement",
                  //             imageUrl: video.dominantShape?.image,
                  //           ),
                  //         ),
                  //        //  Image.network(video.movement?.image??"no image"),
                  //        //
                  //        //  Text(video.dominantShape?.title ?? "No Shape"),
                  //        // SvgPicture.network(video.dominantShape?.image??"no image",
                  //        //   width: 40,
                  //        //   height: 40,
                  //        // ),
                  //
                  //         ListTile(
                  //           leading: Image.network(video.thumbnail),
                  //           title: Text(video.title),
                  //           subtitle: Text(video.titleSecondary),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// class ConceptDetailScreen extends StatelessWidget {
//
//
//   ConceptDetailScreen({required this.conceptId});
//
// }
// class VideoDetailScreen extends StatefulWidget {
//   final ConceptFullDetail data;
//
//   const VideoDetailScreen({Key? key, required this.data})
//       : super(key: key);
//
//   @override
//   State<VideoDetailScreen> createState() => _VideoDetailScreenState();
// }
//
// class _VideoDetailScreenState extends State<VideoDetailScreen> {
//   int selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final videos = widget.data.videos;
//     final video = videos[selectedIndex];
//
//     return Column(
//       children: [
//
//         /// 🔹 SIGN BUTTONS
//         SizedBox(
//           height: 45,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: videos.length,
//             itemBuilder: (context, index) {
//               final isSelected = selectedIndex == index;
//
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 6),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                     isSelected ? Colors.green : Colors.grey.shade300,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       selectedIndex = index;
//                     });
//                   },
//                   child: Text(
//                     "Sign ${index + 1}",
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//
//         const SizedBox(height: 20),
//
//         /// 🔹 Selected Video Data
//         Row(
//           children: [
//             Expanded(
//               child: SmartInfoCard(
//                 title: "Location",
//                 value: video.location?.title ?? "No Location",
//                 imageUrl: video.location?.image,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: SmartInfoCard(
//                 title: "Movement",
//                 value: video.movement?.title ?? "No Movement",
//                 imageUrl: video.movement?.image,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: SmartInfoCard(
//                 title: "Shape",
//                 value: video.dominantShape?.title ?? "No Shape",
//                 imageUrl: video.dominantShape?.image,
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 20),
//
//         /// 🔹 Thumbnail + Title
//         ListTile(
//           leading: Image.network(video.thumbnail),
//           title: Text(video.title),
//           subtitle: Text(video.titleSecondary),
//         ),
//       ],
//     );
//   }
// }
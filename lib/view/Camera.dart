import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../camera/camera_prediction.dart';
import '../camera/live_camera.dart';
import 'home_screen.dart';

class LiveTest extends StatefulWidget {
  const LiveTest({super.key});

  @override
  State<LiveTest> createState() => _LiveTestState();
}

class _LiveTestState extends State<LiveTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Learning Sign"),),
      body: Column(
        
        children: [
          SizedBox(height: 20,),
          Expanded(
            child: GridView.count(
              crossAxisCount: 1,
              padding: EdgeInsets.all(16),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                DashboardTile(
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LiveSignScreen()),
                    );
                  },
                  icon: Icons.live_tv ,
                  label: "Live Camera Learning",
                ),
                DashboardTile(
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignPredictionScreen()),
                    );
                  },
                  icon: Icons.camera ,
                  label: "Image Learning",
                ),



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
          SizedBox(height: 20,)

        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dashboardItems = [
    {"title": "Users", "icon": Icons.people, "color": Colors.blue},
    {"title": "Orders", "icon": Icons.shopping_cart, "color": Colors.green},
    {"title": "Reports", "icon": Icons.bar_chart, "color": Colors.orange},
    {"title": "Settings", "icon": Icons.settings, "color": Colors.purple},
    {"title": "Messages", "icon": Icons.message, "color": Colors.red},
    {"title": "Tracking", "icon": Icons.location_on, "color": Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // Progress Bar
SizedBox(height: 25,),

          // Dashboard Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                DashboardTile(icon: Icons.sign_language, label: "Learn Signs"),
                DashboardTile(icon: Icons.extension, label: "Activities"),
                DashboardTile(icon: Icons.quiz, label: "Quick Quiz"),
                DashboardTile(icon: Icons.video_library, label: "Videos"),
                DashboardTile(icon: Icons.download, label: "Downloads"),
                DashboardTile(icon: Icons.emoji_events, label: "Badges"),
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
class DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;

  DashboardTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.purple),
            SizedBox(height: 10),
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

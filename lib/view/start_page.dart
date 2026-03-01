import 'package:flutter/material.dart';
import 'package:sign_spark/services/streak_service.dart';
import 'package:sign_spark/view/camera_screen.dart';
import 'package:sign_spark/view/home_screen.dart';
import 'package:sign_spark/view/setting_screen.dart';
import 'package:sign_spark/view/tasks_screen.dart';
import 'package:sign_spark/widgets/streak_dialog.dart';

import '../firebase_serivces/firebase_auth.dart';
import 'Camera.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _currntIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    TasksScreen(),
    CameraScrren(),
    SettingsScreen(),
  ];

  void _showStreakDialog(int streak) {
    final streakService = StreakService();
    showDialog(
      context: context,
      builder: (context) => StreakDialog(
        streak: streak,
        milestone: streakService.getStreakMilestone(streak),
        message: streakService.getMotivationalMessage(streak),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        title: Column(
          children: [
            SizedBox(height:20,),
            StreamBuilder(
              stream: UserService().userStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text("Loading...");

                var data = snapshot.data!.data() as Map<String, dynamic>;
                final streak = data["streak"] ?? 0;

                return Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12),
                          Text(
                            data["name"],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showStreakDialog(streak),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: streak >= 7
                                    ? Colors.orange.shade100
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "$streak 🔥",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: streak >= 7
                                          ? Colors.deepOrange
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.info_outline,
                                    size: 14,
                                    color: streak >= 7
                                        ? Colors.deepOrange
                                        : Colors.grey.shade700,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                );
              },

            ),
            SizedBox(height:20,),
          ],
        ),
      ),

      body: _screens[_currntIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          if (value == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsScreen()),
            );
            return;
          }

          setState(() {
            _currntIndex = value;
          });
        },
        selectedIndex: _currntIndex,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.add_circle), label: "Tasks"),
          NavigationDestination(icon: Icon(Icons.camera), label: "Camera"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

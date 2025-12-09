import 'package:flutter/material.dart';
import 'package:sign_spark/view/camera_screen.dart';
import 'package:sign_spark/view/home_screen.dart';
import 'package:sign_spark/view/setting_screen.dart';
import 'package:sign_spark/view/tasks_screen.dart';

import '../firebase_serivces/firebase_auth.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _currntIndex = 0;

  final List<Widget> _screens = [DashboardScreen(), TasksScreen(), CameraScrren(),SettingsScreen(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: StreamBuilder(
          stream: UserService().userStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("Loading...");

        var data = snapshot.data!.data() as Map<String, dynamic>;

        return Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data["name"],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Streak: ${data["streak"]}🔥",
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        );
      },
    )

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

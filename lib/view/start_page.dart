import 'package:flutter/material.dart';
import 'package:sign_spark/view/camera_screen.dart';
import 'package:sign_spark/view/home_screen.dart';
import 'package:sign_spark/view/setting_screen.dart';
import 'package:sign_spark/view/tasks_screen.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _currntIndex = 0;

  final List<Widget> _screens = [HomeScreen(), TasksScreen(), CameraScrren(),SettingScreen(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Sign Spark")),
      backgroundColor: Colors.brown.shade100,
      ),
      body: _screens[_currntIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value){
          setState(() {
            _currntIndex =value;
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

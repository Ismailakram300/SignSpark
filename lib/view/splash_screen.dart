import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:sign_spark/firebase_serivces/firebase_auth.dart';
import 'package:sign_spark/services/streak_service.dart';
import 'package:sign_spark/view/login.dart';
import 'package:sign_spark/view/start_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    _startLoading();
  }
double progress=0.0;
  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        progress += 0.04;
      });

      if (progress >= 1.0) {
        timer.cancel();
        _checkAuthAndNavigate();
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Check if user is already logged in
    final currentUser = FirebaseService().getCurrentUser();
    
    if (currentUser != null) {
      // User is logged in, update streak
      await StreakService().updateStreak();
      
      // Navigate to home
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
        );
      }
    } else {
      // User not logged in, go to login screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/appBackgroung.jpg"),
    fit: BoxFit.cover
        ),

    ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                child: LiquidCircularProgressIndicator(
                  value: progress, // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(
                    Colors.green.shade200,
                  ), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors
                      .white, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.transparent,
                  borderWidth: 5.0,
                  direction: Axis
                      .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  center: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

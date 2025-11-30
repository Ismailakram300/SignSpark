import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraScrren extends StatefulWidget {
  const CameraScrren({super.key});

  @override
  State<CameraScrren> createState() => _CameraScrrenState();
}

class _CameraScrrenState extends State<CameraScrren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Center(
           child: Text("Camera Screeen"),
         ),
       ],
     ),
    );
  }
}

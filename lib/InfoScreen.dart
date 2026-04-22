import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  final String title;
  final String content;

  const InfoScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green.shade600,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(content, style: const TextStyle(fontSize: 15, height: 1.6)),
      ),
    );
  }
}

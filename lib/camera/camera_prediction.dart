import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SignPredictionScreen extends StatefulWidget {
  const SignPredictionScreen({super.key});

  @override
  State<SignPredictionScreen> createState() => _SignPredictionScreenState();
}

class _SignPredictionScreenState extends State<SignPredictionScreen> {
  File? _image;
  String _result = "No prediction yet";
  bool _loading = false;

  final picker = ImagePicker();

  // 🔁 CHANGE THIS IP if needed
  final String apiUrl = "http://192.168.1.6:5000/predict";

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _result = "Image selected";
      });
    }
  }

  Future<void> predictSign() async {
    if (_image == null) return;

    setState(() {
      _loading = true;
      _result = "Predicting...";
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(apiUrl),
      );

      request.files.add(
        await http.MultipartFile.fromPath('image', _image!.path),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      final decoded = jsonDecode(responseBody);

      setState(() {
        _result = decoded['prediction'].toString().toUpperCase();
      });
    } catch (e) {
      setState(() {
        _result = "Error: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _showDisclaimer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("⚠️ How to get accurate results"),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("1. Find a clean wall:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Stand in front of a completely blank wall (e.g., white or solid color) with good lighting."),
              SizedBox(height: 10),
              Text("2. Fill the image:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Make sure your hand dominates the picture so there's almost no background visible."),
              SizedBox(height: 10),
              Text("3. Check hand direction:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Make sure you perform the signs facing the camera as intended."),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("GOT IT"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ASL Sign Prediction"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showDisclaimer,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _image == null
                  ? const Center(child: Text("No image selected"))
                  : Image.file(_image!, fit: BoxFit.cover),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture Image"),
              onPressed: pickImage,
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(Icons.analytics),
              label: const Text("Predict Sign"),
              onPressed: _loading ? null : predictSign,
            ),

            const SizedBox(height: 30),

            Text(
              "Result:",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 10),

            Text(
              _result,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

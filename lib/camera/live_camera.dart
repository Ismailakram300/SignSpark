import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LiveSignScreen extends StatefulWidget {
  const LiveSignScreen({super.key});

  @override
  State<LiveSignScreen> createState() => _LiveSignScreenState();
}

class _LiveSignScreenState extends State<LiveSignScreen> {
  CameraController? _controller;
  bool _isPredicting = false;
  String _result = "Waiting...";

  final String apiUrl = "http://192.168.1.20:5000/predict";

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    setState(() {});

    // 🔁 Auto capture every 1 second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPredicting && mounted) {
        captureAndPredict();
      }
    });
  }

  Future<void> captureAndPredict() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    _isPredicting = true;

    try {
      final XFile picture = await _controller!.takePicture();
      final tempDir = await getTemporaryDirectory();
      final imageFile = File('${tempDir.path}/frame.jpg');
      await picture.saveTo(imageFile.path);

      var request =
      http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var response = await request.send();
      var body = await response.stream.bytesToString();
      final decoded = jsonDecode(body);

      setState(() {
        _result = decoded['prediction'].toString().toUpperCase();
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isPredicting = false;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live ASL Detection"),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: _controller == null
                ? const Center(child: CircularProgressIndicator())
                : CameraPreview(_controller!),
          ),
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.black,
            alignment: Alignment.center,
            child: Text(
              _result,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

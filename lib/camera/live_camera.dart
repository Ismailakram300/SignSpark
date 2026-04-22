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

  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  Timer? _captureTimer;

  final String apiUrl = "http://192.168.1.6:5000/predict";

  @override
  void initState() {
    super.initState();
    initCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDisclaimer();
    });

    // 🔁 Auto capture every 1 second
    _captureTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPredicting && mounted) {
        captureAndPredict();
      }
    });
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
              Text("2. Fill the frame:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Make sure your hand dominates the entirety of the camera frame so there's almost no background visible."),
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

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      await _initCameraController(_cameras[_selectedCameraIndex]);
    }
  }

  Future<void> _initCameraController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.isEmpty) return;

    setState(() {
      _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
      if (_selectedCameraIndex >= _cameras.length) {
        _selectedCameraIndex = 0;
      }
    });

    await _initCameraController(_cameras[_selectedCameraIndex]);
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
    _captureTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live ASL Detection"),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: _flipCamera,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showDisclaimer,
          ),
        ],
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

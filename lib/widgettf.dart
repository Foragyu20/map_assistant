import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

import 'command_assist.dart';

/*
Author: Christian Forest M. Raguini
Description: I made this app experimentally it may have some bugs and may not be stable on other devices and is also hardware dependent.
*/
class TFLiteCameraWidget extends StatefulWidget {
  final void Function(String) onOutputChanged;

  const TFLiteCameraWidget({Key? key, required this.onOutputChanged})
      : super(key: key);

  @override
  TFLiteCameraWidgetState createState() => TFLiteCameraWidgetState();
}

class TFLiteCameraWidgetState extends State<TFLiteCameraWidget> {
  CameraController? _cameraController;
  late Future<void> cameraInitFuture;
  bool _isWorking = false;
  String _output = '';

  @override
  void initState() {
    super.initState();
    initializeCamera();
    loadModel();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(camera, ResolutionPreset.high);
    cameraInitFuture = _cameraController!.initialize();
    await cameraInitFuture; // Wait for camera initialization to complete
    if (mounted) {
      setState(() {});
      _cameraController!.startImageStream(processCameraImage);
    }
  }

  Future<void> loadModel() async {
    const model = 'assets/model_unquant.tflite';
    const labels = 'assets/labels.txt';

    try {
      await Tflite.loadModel(
        model: model,
        labels: labels,
      );
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  void processCameraImage(CameraImage image) async {
    if (_isWorking) return;
    setState(() {
      _isWorking = true;
    });

    var recognitions = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 2,
      threshold: 0.8, // Set minimum threshold to 70%
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      final output = recognitions[0]['label'];
      final confidence = recognitions[0]['confidence'];

      if (confidence >= 0.85 && confidence <= 0.9) {
        // Accept only if confidence is between 70-90%
        widget.onOutputChanged(output); // Invoke the callback function
        setState(() {
          _output = output; // Update the output value
        });
      }
    }

    setState(() {
      _isWorking = false;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: deviceRatio,
            child: CameraPreview(_cameraController!),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              _output,
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),
        Positioned(
          top: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const VoiceCommandMap(), // Replace with your custom widget
                ),
              );
            },
            child: const Icon(
              Icons.map_rounded,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}

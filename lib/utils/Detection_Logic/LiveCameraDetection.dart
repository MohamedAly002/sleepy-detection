import 'package:camera/camera.dart';
import 'package:driver_drowsiness_alert/Widgets/Home/home_screen.dart';
import 'package:driver_drowsiness_alert/utils/Detection_Logic/boundary_box.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'dart:math' as math;

class LiveCameraDetection extends StatefulWidget {
  static const String routeName = 'CameraPreview';

  const LiveCameraDetection({super.key});

  @override
  State<LiveCameraDetection> createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<LiveCameraDetection> {
  CameraImage? _cameraImage;
  String output = "";
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<CameraDescription> cameras = [];
  bool isDetecting = false;
  late List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
    loadModel();
    _recognitions = [];
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(frontCamera, ResolutionPreset.max);
      await _controller.initialize();
      setState(() {
        _controller.startImageStream((imageStream) {
          _cameraImage = imageStream;
          runModel();
        });
      });
    } on CameraException catch (e) {
      _handleCameraException(e);
    }
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model2/model_unquant_drow.tflite",
      labels: "assets/model2/label.txt",
    );
  }

  Future<void> runModel() async {
    if (_cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
        bytesList: _cameraImage!.planes.map((plane) => plane.bytes).toList(),
        imageHeight: _cameraImage!.height,
        imageWidth: _cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 0,
        numResults: 2,
        threshold: 0.5,
        asynch: true,
      ).then(
        (recognitions) {
          setRecognitions(
              recognitions, _cameraImage?.height, _cameraImage?.width);
          isDetecting = false;
        },
      );

      if (predictions != null && predictions.isNotEmpty) {
        setState(() {
          // Iterate over predictions and filter out closed eye detections with higher confidence
          var closedEyeDetection = predictions.firstWhere(
            (prediction) =>
                prediction['label'] == '0 sleepyv' &&
                prediction['confidence'] >
                    0.7, // Adjust confidence threshold as needed
            orElse: () => null,
          );

          output = closedEyeDetection != null ? 'Eyes Closed' : 'Eyes Open';
        });
      }
    }
  }

  void _handleCameraException(CameraException e) {
    String errorMessage = 'Error: ${e.code}\n${e.description}';

    if (e.code == 'CameraAccessDenied') {
      errorMessage =
          'Camera access denied. Please enable camera access in the device settings.';
      _requestCameraPermission();
    } else if (e.code == 'CameraAccessDeniedWithoutPermission') {
      errorMessage =
          'Camera access denied without prompt. Please enable camera access in the device settings.';
    } else if (e.code == 'CameraAccessRestricted') {
      errorMessage =
          'Camera access restricted. Parental control settings may be preventing camera access.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Error'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Camera Preview'),
            centerTitle: true,
            leading: InkWell(
              child: Icon(Icons.cancel_outlined),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: CameraPreview(_controller),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    output,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  )
                ],
              ),
              BoundaryBox(
                  _recognitions,
                  math.max(_imageHeight, _imageWidth),
                  math.min(_imageHeight, _imageWidth),
                  screen.height,
                  screen.width),
            ],
          )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.stopImageStream();
    super.dispose();
  }

  void _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (!status.isGranted) {
      _requestCameraPermission();
    }
  }
}

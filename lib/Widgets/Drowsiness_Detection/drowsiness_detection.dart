import 'package:driver_drowsiness_alert/utils/Detection_Logic/LiveCameraDetection.dart';
import 'package:flutter/material.dart';

class DrowsinessDetection extends StatefulWidget {
  const DrowsinessDetection({Key? key}) : super(key: key);
  static const String routeName = 'DrowsinessDetection';

  @override
  _DrowsinessDetectionState createState() => _DrowsinessDetectionState();
}

class _DrowsinessDetectionState extends State<DrowsinessDetection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Welcome to Sleepy Detection!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'To use this feature effectively, ensure the following:\n\n1. Position your face clearly in front of the camera.\n2. Ensure there is enough lighting in the environment.\n3. Avoid obstructing the camera with objects or hands.\n',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15,),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xFF0583F2))),
                onPressed: () {
                  Navigator.pushNamed(context, LiveCameraDetection.routeName);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Start Detection', style: TextStyle(fontSize: 24,color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

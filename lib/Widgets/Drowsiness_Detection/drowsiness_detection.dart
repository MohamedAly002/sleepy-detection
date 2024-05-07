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
        child: Container(
          child: ElevatedButton(
            onPressed: (){
              Navigator.pushNamed(context, LiveCameraDetection.routeName);
        
            },
           style: ButtonStyle(
        
           ),
            child: Text('Start Detection',style: TextStyle(fontSize: 20),),
          ),
        ),
      ),
    );
  }

}

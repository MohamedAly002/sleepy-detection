import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class BoundaryBox extends StatefulWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  BoundaryBox(
      this.results, this.previewH, this.previewW, this.screenH, this.screenW);

  @override
  _BoundaryBoxState createState() => _BoundaryBoxState();
}

class _BoundaryBoxState extends State<BoundaryBox> {
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stopRingtone();
    super.dispose();
  }

  void _playRingtone() {
    if (!isPlaying) {
      FlutterRingtonePlayer().play(
        fromAsset: "assets/sound/Alarm.wav",
        asAlarm: true,
        looping: true,
        volume: 1.0,
      );
      setState(() {
        isPlaying = true;
      });
    }
  }

  void _stopRingtone() {
    if (isPlaying) {
      FlutterRingtonePlayer().stop();
      setState(() {
        isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _renderStrings(),
    );
  }

  List<Widget> _renderStrings() {
    return widget.results.map((re) {
      try {
        if (re["label"] == '0 Closed' && (re["confidence"] * 100 > 50)) {
          // If eyes are closed with confidence above 50%, play the ringtone
          _playRingtone();
        } else if (re["label"] == '1 Open' && (re["confidence"] * 100 > 70)) {
          // If eyes are open with confidence above 50%, stop the ringtone
          _stopRingtone();
        }
      } catch (err) {
        // Handle any errors
      }
      return Positioned(
        left: (widget.screenW / 3),
        bottom: -(widget.screenH - 80),
        width: widget.screenW,
        height: widget.screenH,
        child: Text(
          "${re["label"] == '0 Closed' ? "Eyes Closed" : "Eyes Open"} ${(re["confidence"] * 100).toStringAsFixed(0)}%",
          style: TextStyle(
            backgroundColor: Colors.white,
            color: re["label"] == '0 Closed' ? Colors.red : Colors.green,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
  }
}

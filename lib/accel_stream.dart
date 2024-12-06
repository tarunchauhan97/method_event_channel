import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class AccelerometerStream extends StatefulWidget {
  @override
  _AccelerometerStreamState createState() => _AccelerometerStreamState();
}

class _AccelerometerStreamState extends State<AccelerometerStream> {
  static const EventChannel _eventChannel =
      EventChannel('com.tarun/accelerometer');

  StreamSubscription<dynamic>? _accelerometerSubscription;

  String _accelerometerData = "No data";

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _accelerometerSubscription = _eventChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        setState(() {
          _accelerometerData =
              "X: ${event['x']}, Y: ${event['y']}, Z: ${event['z']}";
        });
      },
      onError: (dynamic error) {
        setState(() {
          _accelerometerData = "Error: ${error.message}";
        });
      },
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _accelerometerData,
        textAlign: TextAlign.center,
      ),
    );
  }
}

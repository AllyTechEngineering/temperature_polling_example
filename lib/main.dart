import 'dart:async';

import 'package:flutter/material.dart';

// Assume you have a function to read the temperature sensor and control the relay
// This is just a placeholder function for demonstration purposes
class ReadTemperatureValue {
  double temperatureValue = 70.0;
  Future<double> readTemperature() async {
    // Placeholder implementation to simulate temperature reading

    await Future.delayed(Duration(seconds: 1));
    debugPrint('');
    if (temperatureValue < 86) {
      temperatureValue += 1;
    }
    debugPrint('temperatureValue: $temperatureValue');
    return temperatureValue; // Return a hardcoded temperature for demonstration
  }
}

void controlRelay(bool on) {
  // Placeholder function to control the relay
  // Implement your relay control logic here
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TemperatureController(),
    );
  }
}

class TemperatureController extends StatefulWidget {
  const TemperatureController({super.key});

  @override
  _TemperatureControllerState createState() => _TemperatureControllerState();
}

class _TemperatureControllerState extends State<TemperatureController> {
  final ReadTemperatureValue readTemperatureValue = ReadTemperatureValue();
  bool isSystemOn = false;
  bool isRelayOn = false;
  double currentTemperature = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Controller'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Temperature: ${currentTemperature.toStringAsFixed(1)}°C',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Relay Status: ${isRelayOn ? 'ON' : 'OFF'}',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'System:',
                  style: TextStyle(fontSize: 24.0),
                ),
                Switch(
                  value: isSystemOn,
                  onChanged: (value) {
                    setState(() {
                      isSystemOn = value;
                      if (isSystemOn) {
                        _startTemperatureMonitoring();
                      } else {
                        _stopTemperatureMonitoring();
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startTemperatureMonitoring() {
    // Start continuous temperature monitoring
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if (isSystemOn) {
        double temperature = await readTemperatureValue.readTemperature();
        setState(() {
          currentTemperature = temperature;
          if (temperature >= 85.0) {
            isRelayOn = true;
            controlRelay(true);
          } else {
            isRelayOn = false;
            controlRelay(false);
          }
        });
      } else {
        timer.cancel(); // Stop monitoring if system is turned off
      }
    });
  }

  void _stopTemperatureMonitoring() {
    // Stop continuous temperature monitoring
    setState(() {
      isRelayOn = false;
      controlRelay(false);
    });
  }
}

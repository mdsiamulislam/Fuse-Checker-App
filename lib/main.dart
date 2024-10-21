import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuse Checker App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Fuse Checker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String fuseStatus = "Place the fuse and touch the screen";

  // This method checks if the touch is inside the circular area
  void _checkFuseStatus(Offset position) {
    // Define the center of the circle (adjust based on your UI)
    Offset circleCenter = Offset(MediaQuery.of(context).size.width / 2, 300);
    double circleRadius = 100;

    // Check if the touch is inside the circle (within the radius)
    double distanceFromCenter = (position - circleCenter).distance;
    if (distanceFromCenter <= circleRadius) {
      setState(() {
        fuseStatus = "Fuse OK"; // If touch is within the circle, fuse is OK
      });
    } else {
      setState(() {
        fuseStatus = "Fuse Damaged"; // Otherwise, fuse is damaged
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          onPanUpdate: (details) {
            // Call the fuse checking method when user touches the screen
            _checkFuseStatus(details.localPosition);
          },
          child: Stack(
            children: [
              // Circular area for fuse placement
              Positioned(
                top: 200,
                left: MediaQuery.of(context).size.width / 2 - 100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 4),
                  ),
                  child: Center(
                    child: Text(
                      'Place Fuse Here',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              // Fuse status text
              Positioned(
                bottom: 150,
                left: MediaQuery.of(context).size.width / 2 - 75,
                child: Text(
                  fuseStatus,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

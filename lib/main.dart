import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Fuse Checker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Modern Fuse Checker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  String fuseStatus = "Place the fuse and touch the screen";
  bool fuseOk = false;
  bool isTouching = false;

  late AnimationController _controller;
  late Animation<Color?> _iconColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _iconColorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.teal,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Check if the touch is inside the circle
  void _checkFuseStatus(Offset position) {
    Offset circleCenter = Offset(MediaQuery.of(context).size.width / 2, 300);
    double circleRadius = 120;

    double distanceFromCenter = (position - circleCenter).distance;
    if (distanceFromCenter <= circleRadius) {
      setState(() {
        fuseOk = true;
        fuseStatus = "Fuse OK";
        _controller.forward(); // Start animation
      });
    } else {
      setState(() {
        fuseOk = false;
        fuseStatus = "Fuse Damaged";
        _controller.reverse(); // Reverse animation
      });
    }
  }

  // Reset fuse status when touch is released
  void _resetFuseStatus() {
    setState(() {
      fuseStatus = "Ready for another test";
      isTouching = false;
    });
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
            _checkFuseStatus(details.localPosition);
            setState(() {
              isTouching = true;
            });
          },
          onPanEnd: (details) {
            _resetFuseStatus();
            _controller.reverse();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Modern Circular Area
              Positioned(
                top: 200,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: fuseOk
                          ? [Colors.teal.shade300, Colors.teal.shade800]
                          : [Colors.red.shade300, Colors.red.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: fuseOk ? Colors.tealAccent.withOpacity(0.5) : Colors.redAccent.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Place Fuse Here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Fuse Status Card
              Positioned(
                bottom: 150,
                child: AnimatedContainer(
                  padding: const EdgeInsets.all(20),
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: fuseOk ? Colors.teal.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        fuseOk ? Icons.check_circle_outline : Icons.error_outline,
                        size: 50,
                        color: fuseOk ? Colors.teal : Colors.red,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        fuseStatus,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: fuseOk ? Colors.teal.shade700 : Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Animated Fuse Icon
              Positioned(
                bottom: 80,
                child: AnimatedBuilder(
                  animation: _iconColorAnimation,
                  builder: (context, child) => Icon(
                    Icons.power,
                    color: _iconColorAnimation.value,
                    size: 60,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Interface Lab',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: AnimatedPage(),
    );
  }
}

class AnimatedPage extends StatefulWidget {
  @override
  _AnimatedPageState createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _box1Size;
  late Animation<Offset> _box1Position;
  late Animation<double> _box2Opacity;
  late Animation<Offset> _box2Position;
  late Animation<double> _box3Size;
  late Animation<Offset> _box3Position;

  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController with a duration of 3 seconds
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Staggered Animations for Box 1
    _box1Size = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.3, curve: Curves.easeIn), // Ease-in curve
      ),
    );
    _box1Position =
        Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Staggered Animations for Box 2
    _box2Opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.6, curve: Curves.easeOut), // Ease-out curve
      ),
    );
    _box2Position =
        Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    // Staggered Animations for Box 3
    _box3Size = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 1.0, curve: Curves.bounceOut), // Bounce-out curve
      ),
    );
    _box3Position =
        Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 1.0, curve: Curves.bounceOut),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controller properly to avoid memory leaks
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    // Toggle animation state
    setState(() {
      _isAnimated = !_isAnimated;
      _isAnimated ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Interface Lab'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Staggered Animation for Box 1
            SlideTransition(
              position: _box1Position,
              child: AnimatedBuilder(
                animation: _box1Size,
                builder: (context, child) {
                  return Container(
                    width: _box1Size.value,
                    height: _box1Size.value,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Staggered Animation for Box 2 (Fade & Slide)
            SlideTransition(
              position: _box2Position,
              child: FadeTransition(
                opacity: _box2Opacity,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Staggered Animation for Box 3
            SlideTransition(
              position: _box3Position,
              child: AnimatedBuilder(
                animation: _box3Size,
                builder: (context, child) {
                  return Container(
                    width: _box3Size.value,
                    height: _box3Size.value,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            // Button to start/reverse animation
            Tooltip(
              message: 'Click to toggle animation',
              child: ElevatedButton(
                onPressed: _toggleAnimation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _isAnimated ? 'Reverse Animation' : 'Start Animation',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Draggable widget
            DraggableWidget(),
          ],
        ),
      ),
    );
  }
}

class DraggableWidget extends StatefulWidget {
  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  double x = 0.0;
  double y = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Update the widget position based on user drag
        setState(() {
          x += details.delta.dx;
          y += details.delta.dy;
        });
      },
      child: Transform.translate(
        offset: Offset(x, y),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "Drag me",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

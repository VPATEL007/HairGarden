import 'package:flutter/material.dart';

class CustomTextAnimation extends StatefulWidget {
  @override
  _CustomTextAnimationState createState() => _CustomTextAnimationState();
}

class _CustomTextAnimationState extends State<CustomTextAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _controller2;
  late Animation<double> _animation2;
  bool isShown = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Adjust the duration as per your preference
    );

    _animation = Tween<double>(begin: -3.0, end: 0.0).animate(_controller);

    // Start the animation
    _controller.forward();
    Future.delayed(Duration(seconds: 2)).then((value)
    {
      setState(() {
        isShown=true;
      });
      _controller2 = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1), // Adjust the duration as per your preference
      );

      _animation2 = Tween<double>(begin: 1.0, end: 0.0).animate(_controller2);

      // Start the animation
      _controller2.forward();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Animation'),
      ),
      body: Column(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Align(
                alignment: Alignment(_animation.value, 0),
                child: Text(
                  'First Text',
                  style: TextStyle(fontSize: 24.0),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Align(
                alignment: Alignment(-_animation.value, 0),
                child: Text(
                  'Second Text',
                  style: TextStyle(fontSize: 24.0),
                ),
              );
            },
          ),
          isShown?AnimatedBuilder(
            animation: _controller2,
            builder: (context, child) {
              return Align(
                alignment: Alignment(-_animation.value, 30),
                child: Text(
                  'Third Text',
                  style: TextStyle(fontSize: 24.0),
                ),
              );
            },
          ):SizedBox(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

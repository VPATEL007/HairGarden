import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController? text1Controller;
  AnimationController? text2Controller;
  Animation<double>? text1Animation;
  Animation<double>? text2Animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    text1Controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    text2Controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Define animations
    text1Animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: text1Controller!,
      curve: Curves.easeIn,
    ));
    text2Animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: text2Controller!,
      curve: Curves.easeIn,
    ));

    // Start animations
    text1Controller?.forward();
    text2Controller?.forward();
  }

  @override
  void dispose() {
    text1Controller?.dispose();
    text2Controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // DefaultTextStyle(
            //   style: const TextStyle(
            //     fontSize: 40.0,
            //     fontFamily: 'Horizon',
            //   ),
            //   child: AnimatedTextKit(
            //     animatedTexts: [
            //       FadeAnimatedText('AWESOME'),
            //       FadeAnimatedText('OPTIMISTIC'),
            //       FadeAnimatedText('DIFFERENT'),
            //     ],
            //     onTap: () {
            //       print("Tap Event");
            //     },
            //   ),
            // ),
            SlideTransition(
              position: text1Animation!.drive(Tween(begin: Offset(0.0, 0.0), end: Offset(0.0, 0.0))),
              child: Text(
                'Text from left',
                style: TextStyle(fontSize: 24),
              ),
            ),
            // SlideTransition(
            //   position: text2Animation!.drive(AlignmentTween(
            //     begin: Alignment.topLeft,
            //     end: Alignment.topRight,
            //   ),),
            //   child: TypewriterAnimatedTextKit(
            //     text: ['Text from bottom'],
            //     textStyle: TextStyle(fontSize: 24),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

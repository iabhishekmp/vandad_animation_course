import 'dart:math' show pi;

import 'package:flutter/material.dart';

class Example2 extends StatefulWidget {
  const Example2({super.key});

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> with TickerProviderStateMixin {
  late AnimationController rotationController;
  late Animation<double> rotationAnimation;

  late AnimationController flipController;
  late Animation<double> flipAnimation;

  @override
  void initState() {
    super.initState();
    //? rotation animation
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    rotationAnimation = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(
      CurvedAnimation(
        parent: rotationController,
        curve: Curves.bounceOut,
      ),
    );

    //? flip animation
    flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(
      CurvedAnimation(
        parent: flipController,
        curve: Curves.bounceOut,
      ),
    );

    rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        flipAnimation = Tween<double>(
          begin: flipAnimation.value,
          end: flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(
            parent: flipController,
            curve: Curves.bounceOut,
          ),
        );

        // reset the flip controller
        flipController
          ..reset()
          ..forward();
      }
    });

    flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rotationAnimation = Tween<double>(
          begin: rotationAnimation.value,
          end: rotationAnimation.value - (pi / 2),
        ).animate(
          CurvedAnimation(
            parent: rotationController,
            curve: Curves.bounceOut,
          ),
        );

        // reset the flip controller
        rotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    rotationController.dispose();
    flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      rotationController
        ..reset()
        ..forward();
    });
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: AnimatedBuilder(
            animation: rotationController,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateZ(rotationAnimation.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                        animation: flipController,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..rotateY(flipAnimation.value),
                            alignment: Alignment.centerRight,
                            child: ClipPath(
                              clipper: const HalfCircleClipper(
                                  side: CircleSide.left),
                              child: Container(
                                height: 200,
                                width: 200,
                                color: Colors.blue,
                              ),
                            ),
                          );
                        }),
                    AnimatedBuilder(
                        animation: flipController,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..rotateY(flipAnimation.value),
                            alignment: Alignment.centerLeft,
                            child: ClipPath(
                              clipper: const HalfCircleClipper(
                                  side: CircleSide.right),
                              child: Container(
                                height: 200,
                                width: 200,
                                color: Colors.yellow,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

enum CircleSide {
  left,
  right,
}

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    //? 2 things need to calculate
    late Offset offset; // where you want to go
    late bool clockwise;

    // calculation
    switch (this) {
      case CircleSide.left:
        // move the pen to right side of the canvas
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }

    // draw arc
    path.arcToPoint(
      offset,
      clockwise: clockwise,
      radius: Radius.elliptical(
        size.width / 2,
        size.height / 2,
      ),
    );

    // close the path
    path.close();

    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;
  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class Example3 extends StatefulWidget {
  const Example3({super.key});

  @override
  State<Example3> createState() => _Example3State();
}

class _Example3State extends State<Example3> with TickerProviderStateMixin {
  final height = 200.0;

  late final AnimationController xController;
  late final AnimationController yController;
  late final AnimationController zController;
  late final Tween<double> animation;

  @override
  void initState() {
    super.initState();
    xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
    yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    );
    zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 35),
    );

    animation = Tween(
      begin: 0,
      end: pi * 2,
    );
  }

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    xController
      ..reset()
      ..repeat();
    yController
      ..reset()
      ..repeat();
    zController
      ..reset()
      ..repeat();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example 3'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height,
            width: double.infinity,
          ),
          AnimatedBuilder(
              animation: Listenable.merge([
                xController,
                yController,
                zController,
              ]),
              builder: (context, _) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(animation.evaluate(xController))
                    ..rotateY(animation.evaluate(yController))
                    ..rotateZ(animation.evaluate(zController)),
                  child: Stack(
                    children: [
                      //? back
                      Transform(
                        transform: Matrix4.identity()
                          ..translate(
                            Vector3(
                              0,
                              0,
                              -height,
                            ),
                          ),
                        child: Container(
                          height: height,
                          width: height,
                          color: Colors.purple,
                        ),
                      ),

                      //? left
                      Transform(
                        transform: Matrix4.identity()..rotateY(pi / 2),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: height,
                          width: height,
                          color: Colors.green,
                        ),
                      ),

                      //? top
                      Transform(
                        transform: Matrix4.identity()..rotateX(-pi / 2),
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: height,
                          width: height,
                          color: Colors.blue,
                        ),
                      ),

                      //? right
                      Transform(
                        transform: Matrix4.identity()..rotateY(-pi / 2),
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: height,
                          width: height,
                          color: Colors.yellow,
                        ),
                      ),

                      //? front
                      Container(
                        height: height,
                        width: height,
                        color: Colors.red,
                      ),

                      //? bottom
                      Transform(
                        transform: Matrix4.identity()..rotateX(pi / 2),
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: height,
                          width: height,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}

import 'dart:math' show pi, cos, sin;

import 'package:flutter/material.dart';

class Example7 extends StatefulWidget {
  const Example7({super.key});

  @override
  State<Example7> createState() => _Example7State();
}

class _Example7State extends State<Example7> with TickerProviderStateMixin {
  late final AnimationController sideAnimationController;
  late final Animation<int> sideAnimation;

  late final AnimationController radiusAnimationController;
  late final Animation<double> radiusAnimation;

  late final AnimationController rotationAnimationController;
  late final Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();
    sideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    sideAnimation = IntTween(
      begin: 3,
      end: 10,
    ).animate(sideAnimationController);

    radiusAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    radiusAnimation = Tween<double>(
      begin: 20,
      end: 400,
    )
        .chain(CurveTween(curve: Curves.bounceInOut))
        .animate(radiusAnimationController);

    rotationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    )
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(rotationAnimationController);
  }

  @override
  void dispose() {
    sideAnimationController.dispose();
    radiusAnimationController.dispose();
    rotationAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sideAnimationController.repeat(reverse: true);
    radiusAnimationController.repeat(reverse: true);
    rotationAnimationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example7'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            sideAnimationController,
            radiusAnimationController,
            rotationAnimationController,
          ]),
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(rotationAnimation.value)
                ..rotateY(rotationAnimation.value)
                ..rotateZ(rotationAnimation.value),
              child: CustomPaint(
                painter: Polygon(sides: sideAnimation.value),
                child: SizedBox(
                  height: radiusAnimation.value,
                  width: radiusAnimation.value,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Polygon extends CustomPainter {
  final int sides;

  Polygon({
    required this.sides,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    /*
      to move a pen to some point on circle,
      x = center.x + radius * cos(angle);
      y = center.y + radius * sin(angle);
    */

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    path.moveTo(
      center.dx + radius * cos(0),
      center.dy + radius * sin(0),
    );

    /*
      [0,1,2];
      angle = 120;
      [0, 120, 240] //index * angle;
    */
    final angles = List.generate(sides, (index) => index * ((2 * pi) / sides));

    for (var angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is Polygon && oldDelegate.sides != sides;
}

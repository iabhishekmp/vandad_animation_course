import 'dart:math' show pi, cos, sin;

import 'package:flutter/material.dart';

class Example7 extends StatelessWidget {
  const Example7({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example7'),
      ),
      body: Center(
        child: SizedBox(
          height: 500,
          width: 500,
          child: CustomPaint(
            painter: Polygon(sides: 5),
          ),
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

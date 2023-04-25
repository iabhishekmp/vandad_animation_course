import 'dart:math' as math;

import 'package:flutter/material.dart';

class Example6 extends StatefulWidget {
  const Example6({super.key});

  @override
  State<Example6> createState() => _Example6State();
}

Color randomColor() => Color(0xFF000000 + math.Random().nextInt(0x00FFFFFF));

class _Example6State extends State<Example6> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example6'),
      ),
      body: Center(
        child: ClipPath(
          clipper: CircleClipper(),
          child: TweenAnimationBuilder(
              tween: ColorTween(
                begin: randomColor(),
                end: randomColor(),
              ),
              onEnd: () => setState(() {}),
              duration: const Duration(milliseconds: 500),
              child: Container(
                color: Colors.red,
                height: 500,
                width: 500,
              ),
              builder: (context, color, child) {
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    color!,
                    BlendMode.srcATop,
                  ),
                  child: child!,
                );
              }),
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final oval = Rect.fromCenter(
      height: size.height,
      width: size.width,
      center: Offset(size.width / 2, size.height / 2),
    );

    path.addOval(oval);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

import 'package:flutter/material.dart';
import 'package:vandad_animation_course/example_1_rotate_box.dart';

import 'example_2_circle_loader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          background: Colors.grey.shade900,
          primary: Colors.white,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            PageButton(
              page: Example1(),
              text: 'Example1: Rotate box',
            ),
            PageButton(
              page: Example2(),
              text: 'Example2: Circle loader',
            ),
          ],
        ),
      ),
    );
  }
}

class PageButton extends StatelessWidget {
  const PageButton({
    super.key,
    required this.page,
    required this.text,
  });

  final Widget page;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Text(text),
    );
  }
}

import 'package:flutter/material.dart';

class Example5 extends StatefulWidget {
  const Example5({super.key});

  @override
  State<Example5> createState() => _Example5State();
}

class _Example5State extends State<Example5> {
  bool isZoomedIn = false;
  String buttonTitle = "Zoom In";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example5'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height:
                    isZoomedIn ? MediaQuery.of(context).size.height - 100 : 300,
                curve: Curves.easeOutCirc,
                child: Image.asset(
                  'assets/images/1.png',
                  fit: BoxFit.contain,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isZoomedIn = !isZoomedIn;
                    buttonTitle = isZoomedIn ? 'Zoom Out' : 'Zoom In';
                  });
                },
                child: Text(buttonTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

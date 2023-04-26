import 'dart:developer';
import 'dart:math' show pi;

import 'package:flutter/material.dart';

class Example8 extends StatelessWidget {
  const Example8({super.key});

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      drawer: Material(
        child: ColoredBox(
          color: const Color(0xff24283b),
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 100, top: 100),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Example8'),
        ),
        body: Container(
          color: const Color(0xff414868),
        ),
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
    required this.child,
    required this.drawer,
  });

  final Widget child;
  final Widget drawer;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  late final AnimationController childAnimationController;
  late final Animation<double> childAnimation;

  late final AnimationController drawerAnimationController;
  late final Animation<double> drawerAnimation;

  @override
  void initState() {
    super.initState();
    //? child animation
    childAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    childAnimation = Tween<double>(
      begin: 0,
      end: -pi / 2,
    ).animate(childAnimationController);

    //? drawer animation
    drawerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    drawerAnimation = Tween<double>(
      begin: pi / 2.7,
      end: 0,
    ).animate(drawerAnimationController);
  }

  @override
  void dispose() {
    childAnimationController.dispose();
    drawerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDrag = screenWidth * 0.8;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final delta = details.delta.dx / maxDrag;
        childAnimationController.value += delta;
        drawerAnimationController.value += delta;

        log(childAnimationController.value.toString());
        log(drawerAnimationController.value.toString());
      },
      onHorizontalDragEnd: (details) {
        if (childAnimationController.value < 0.5) {
          childAnimationController.reverse();
          drawerAnimationController.reverse();
        } else {
          childAnimationController.forward();
          drawerAnimationController.forward();
        }
      },
      child: AnimatedBuilder(
          animation: Listenable.merge([
            childAnimationController,
            drawerAnimationController,
          ]),
          builder: (context, _) {
            return Stack(
              children: [
                //? back
                Container(color: const Color(0xff1a1b26)),

                //? middle
                Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..translate(childAnimationController.value * maxDrag)
                    ..rotateY(childAnimation.value),
                  child: widget.child,
                ),

                //? top
                Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..translate(-screenWidth +
                        drawerAnimationController.value * maxDrag)
                    ..rotateY(drawerAnimation.value),
                  child: widget.drawer,
                ),
              ],
            );
          }),
    );
  }
}

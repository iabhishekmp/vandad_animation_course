import 'package:flutter/material.dart';

class Example4 extends StatelessWidget {
  const Example4({super.key});

  final people = const [
    Person(name: 'John', age: 23, emoji: '😎'),
    Person(name: 'Jane', age: 18, emoji: '🐈'),
    Person(name: 'Jack', age: 24, emoji: '👻'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example4'),
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (BuildContext context, int index) {
          final p = people[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(person: p),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Hero(
                    tag: p.name,
                    child: Text(
                      p.emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        p.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        '${p.age} years old',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_rounded,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;

  const Person({
    required this.name,
    required this.age,
    required this.emoji,
  });
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Hero(
          flightShuttleBuilder: (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) {
            switch (flightDirection) {
              case HeroFlightDirection.push:
                return Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                    scale: animation.drive(
                      Tween(
                        begin: 0.0,
                        end: 1.0,
                      ).chain(
                        CurveTween(
                          curve: Curves.slowMiddle,
                        ),
                      ),
                    ),
                    child: toHeroContext.widget,
                  ),
                );
              case HeroFlightDirection.pop:
                return Material(
                  color: Colors.transparent,
                  child: fromHeroContext.widget,
                );
            }
          },
          tag: person.name,
          child: Text(
            person.emoji,
            style: const TextStyle(fontSize: 40),
          ),
        ),
      ),
      body: Center(
        child: Text(
          person.name,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}

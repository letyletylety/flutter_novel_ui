import 'package:flutter/material.dart';

void main(List<String> args) => runApp(const MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: SphereOfDestiny(diameter: 50)),
    );
  }
}

class SphereOfDestiny extends StatelessWidget {
  const SphereOfDestiny({Key? key, required this.diameter}) : super(key: key);

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.grey, Colors.black],
            center: Alignment(0, -0.75),
          ),
          // color: Colors.black,
          shape: BoxShape.circle),
    );
  }
}

class Magic8Ball extends StatefulWidget {
  const Magic8Ball({Key? key}) : super(key: key);

  @override
  _Magic8BallState createState() => _Magic8BallState();
}

class _Magic8BallState extends State<Magic8Ball> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

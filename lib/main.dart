import 'package:flutter/material.dart';
import 'dart:math' as math;

void main(List<String> args) => runApp(const MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Magic8Ball(),
      ),
    );
  }
}

class SphereOfDestiny extends StatelessWidget {
  const SphereOfDestiny({
    Key? key,
    required this.diameter,
    required this.lightSource,
    required this.child,
  }) : super(key: key);

  final Offset lightSource;
  final double diameter;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: const [Colors.grey, Colors.black],
            center: Alignment(
              lightSource.dx,
              lightSource.dy,
            ),
          ),
          // color: Colors.black,
          shape: BoxShape.circle),
      child: child,
    );
  }
}

class ShadowOfDoubt extends StatelessWidget {
  final double diameter;

  const ShadowOfDoubt({super.key, required this.diameter});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Magic8Ball extends StatefulWidget {
  const Magic8Ball({Key? key}) : super(key: key);

  @override
  _Magic8BallState createState() => _Magic8BallState();
}

class _Magic8BallState extends State<Magic8Ball>
    with SingleTickerProviderStateMixin {
  static const lightSource = Offset(0, -0.75);
  static const restPosition = Offset(0, -0.15);

  String prediction = 'The MAGIC\n8-Ball';
  final predictions = [
    'Drag the Magic 8-Ball around\n'
        'while concentrating on\n'
        'the question you most\n'
        'want answered.\n\n'
        'Let go, and the oracle will\n'
        'give you an answer - of sorts!'
  ];
  Offset tapPosition = Offset.zero;
  double wobble = 0.0;

  late AnimationController controller; // 2

  void _start(Offset offset, Size size) {
    controller.forward(from: 0);
    _update(offset, size);
  }

  void _update(Offset position, Size size) {
    Offset tapPosition = Offset((2 * position.dx / size.width) - 1,
        (2 * position.dy / size.height) - 1);
    if (tapPosition.distance > 0.85) {
      tapPosition = Offset.fromDirection(tapPosition.direction, 0.85);
    }
    setState(() => this.tapPosition = tapPosition);
  }

  void _end() {
    final rand = math.Random();
    prediction = predictions[rand.nextInt(predictions.length)];
    wobble = rand.nextDouble() * (wobble.isNegative ? 0.5 : -0.5);

    controller.reverse(from: 1);
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 1500));
    controller.addListener(() => setState(() => null));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final windowPosition =
        Offset.lerp(restPosition, tapPosition, controller.value)!;

    final size = Size.square(MediaQuery.of(context).size.shortestSide);
    return Stack(
      children: [
        GestureDetector(
          onPanStart: (details) => _start(details.localPosition, size),
          onPanUpdate: (details) => _update(details.localPosition, size),
          onPanEnd: (_) => _end(),
          child: SphereOfDestiny(
              lightSource: lightSource,
              diameter: size.shortestSide,
              child: Transform(
                origin: size.center(Offset.zero),
                // transform: Matrix4.identity()..scale(0.5),
                transform: Matrix4.identity()
                  ..translate(windowPosition.dx * size.width / 2,
                      windowPosition.dy * size.height / 2)
                  ..scale(0.5 - 0.15 * windowPosition.distance)
                  ..rotateZ(windowPosition.direction)
                  ..rotateY(windowPosition.distance * math.pi / 2)
                  ..rotateZ(-windowPosition.direction),

                child: WindowOfOpportunity(
                  lightSource: lightSource - windowPosition,
                  child: Opacity(
                      opacity: 1 - controller.value, // fading out when moving

                      child: Transform.rotate(
                          angle: wobble, child: Prediction(text: prediction))),
                ),
              )),
        ),
        ShadowOfDoubt(diameter: size.shortestSide)
      ],
    );
  }
}

class Prediction extends StatelessWidget {
  const Prediction({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}

class WindowOfOpportunity extends StatelessWidget {
  const WindowOfOpportunity(
      {Key? key, required this.lightSource, required this.child})
      : super(key: key);

  final Offset lightSource;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final innerShadowWidth = lightSource.distance * 0.1;
    final portalShadowOffset =
        Offset.fromDirection(math.pi + lightSource.direction, innerShadowWidth);

    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              stops: [1 - innerShadowWidth, 1],
              colors: [Color(0x661F1F1F), Colors.black],
            )),
        child: child);
  }
}

import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class WinConfettiWidget extends StatefulWidget {
  const WinConfettiWidget({super.key, required this.child});

  final Widget child;

  @override
  State<WinConfettiWidget> createState() => _WinConfettiWidgetState();
}

class _WinConfettiWidgetState extends State<WinConfettiWidget> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  Path createGoldCoinPath(Size size) {
    Path path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
    );
    path.close();
    return path;
  }

  Path createStarPath(Size size) {
    final Path path = Path();
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = min(centerX, centerY);
    final double innerRadius = radius * 0.5; // Adjust inner radius for the star

    const int numPoints = 5;
    final double angle = (2 * pi) / numPoints;
    final double rotation = pi / 2; // Rotate the star by 90 degrees

    for (int i = 0; i < numPoints * 2; i++) {
      // Determine if it's an outer or inner point
      final bool isOuterPoint = i.isEven;
      final double currentRadius = isOuterPoint ? radius : innerRadius;

      // Calculate the angle for each point
      final double x = centerX + currentRadius * cos(i * angle - rotation);
      final double y = centerY + currentRadius * sin(i * angle - rotation);

      // Move to the first point, then draw a line to subsequent points
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ConfettiWidget(
          confettiController: _controllerCenter,
          blastDirectionality: BlastDirectionality.explosive,
          // don't specify a direction, blast randomly
          // shouldLoop: true,
          // start again as soon as the animation is finished
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ],
          createParticlePath: createStarPath, // define a custom shape/path.
          strokeWidth: 8,
          strokeColor: Colors.yellowAccent,
        ),
        widget.child
      ],
    );
  }
}

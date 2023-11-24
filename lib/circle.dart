import 'package:flutter/material.dart';
import 'dart:math';

class ScoreCircle extends StatefulWidget {
  final int score;

  ScoreCircle({required this.score});

  @override
  _ScoreCircleState createState() => _ScoreCircleState();
}

class _ScoreCircleState extends State<ScoreCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Set up the animation controller
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));

    // Set up the animation
    _animation = Tween<double>(begin: 0.0, end: widget.score / 10.0)
        .animate(_animationController);

    // Start the animation
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(_animation.value),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  final double fillRatio;

  CirclePainter(this.fillRatio);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue // Change the color as needed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0; // Adjust the stroke width as needed

    double radius = size.width / 5;
    double centerX = size.width / 5;
    double centerY = size.height / 5;

    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    Paint fillPaint = Paint()
      ..color = Colors.black // Change the fill color as needed
      ..style = PaintingStyle.fill
      ..strokeWidth = 15.0;


    double fillRadius = radius * fillRatio;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -pi / 10, // Start angle
      2 * (pi) * fillRatio, // Sweep angle
      true,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
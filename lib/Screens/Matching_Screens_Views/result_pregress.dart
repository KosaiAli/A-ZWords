import 'dart:math';

import 'package:flutter/material.dart';

class ResultProgress extends CustomPainter {
  ResultProgress(
      {required this.number,
      required this.correctOnes,
      required this.animation});
  final int number;
  final double correctOnes;
  final double animation;

  @override
  void paint(Canvas canvas, Size size) {
    Offset c = Offset(size.width / 2, size.height / 2);
    double radius = max(size.height / 2, size.width / 2);
    Paint paint = Paint()
      ..strokeWidth = 23
      ..style = PaintingStyle.stroke
      ..color = Colors.grey;
    Path path = Path()
      ..addArc(Rect.fromCircle(center: c.translate(0, 10), radius: radius), 0,
          pi * 2)
      ..addArc(Rect.fromCircle(center: c.translate(0, -10), radius: radius), 0,
          pi * 2)
      ..addArc(Rect.fromCircle(center: c.translate(5, 0), radius: radius), 0,
          pi * 2);
    canvas.drawShadow(path, Colors.black, 20, true);
    canvas.drawCircle(c, radius, paint);
    canvas.drawArc(
        Rect.fromCenter(center: c, width: size.width, height: size.height),
        0,
        pi * animation * 2,
        false,
        paint..color = Colors.red);
    canvas.drawArc(
        Rect.fromCenter(center: c, width: size.width, height: size.height),
        0,
        pi * (correctOnes * animation / number) * 2,
        false,
        paint..color = Colors.blue);
    // canvas.drawCircle(
    //     c,
    //     radius - 10,
    //     paint
    //       ..style = PaintingStyle.fill
    //       ..color = Colors.white
    //       ..strokeWidth = 0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

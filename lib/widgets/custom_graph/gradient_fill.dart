import 'package:flutter/material.dart';

import 'package:new_app/utils/indexed_iterables.dart';
import 'dart:ui' as ui;

class PaintFill extends StatefulWidget {
  final List<GFCoordinates> fillCoordinates;
  final double yHeight;

  PaintFill({required this.fillCoordinates, required this.yHeight});

  @override
  _DrawLinesState createState() => _DrawLinesState();
}

class _DrawLinesState extends State<PaintFill> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: widget.fillCoordinates.isNotEmpty
          ? CustomPaint(
              foregroundPainter: FillPainter(
                  fillCoordinates: widget.fillCoordinates,
                  yHeight: widget.yHeight),
            )
          : null,
    );
  }
}

class GFCoordValues {
  late double x;
  late double y;

  GFCoordValues({required this.x, required this.y});
}

class GFCoordinates {
  late GFCoordValues startCoords;
  late GFCoordValues endCoords;

  GFCoordinates({required this.startCoords, required this.endCoords});
}

class FillPainter extends CustomPainter {
  late List<GFCoordinates> fillCoordinates;
  late double yHeight;

  FillPainter({required this.fillCoordinates, required this.yHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.red
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, yHeight),
        [
          Color(0xFF1EBAE3),
          Color(0xFF1EBAE3).withOpacity(0),
        ],
        [
          0.2,
          0.7
        ]
      )
      ..style = PaintingStyle.fill;

    Path path = Path();

    /* 
    path.lineTo(0, yHeight - fillCoordinates[0].startCoords.y);
    path.lineTo(fillCoordinates[0].startCoords.x + 15,
        yHeight - fillCoordinates[0].startCoords.y); */
  path.moveTo(20, yHeight);
    fillCoordinates.forEachIndexed((element, index) {
      path.lineTo(element.startCoords.x + 15, yHeight - element.startCoords.y);

      path.lineTo(element.endCoords.x + 15, yHeight - element.endCoords.y);
    });

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

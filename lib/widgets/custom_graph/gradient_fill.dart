import 'package:flutter/material.dart';

import 'package:new_app/utils/indexed_iterables.dart';
import 'dart:ui' as ui;

class PaintFill extends StatefulWidget {
  final List<GFCoordinates> fillCoordinates;
  final double graphHeight;

  PaintFill({required this.fillCoordinates, required this.graphHeight});

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
                  graphHeight: widget.graphHeight),
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
  late double graphHeight;

  FillPainter({required this.fillCoordinates, required this.graphHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.red
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, graphHeight),
        [
          Color(0xff94E2FF),
          Color(0xFF94E2FF).withOpacity(0),
        ],
        [
          0.2,
          0.5
        ]
      )
      ..style = PaintingStyle.fill;

    Path path = Path();

    /* 
    path.lineTo(0, graphHeight - fillCoordinates[0].startCoords.y);
    path.lineTo(fillCoordinates[0].startCoords.x + 15,
        graphHeight - fillCoordinates[0].startCoords.y); */
  path.moveTo(20, graphHeight);
    fillCoordinates.forEachIndexed((element, index) {
      path.lineTo(element.startCoords.x + 15, graphHeight  - element.startCoords.y);

      path.lineTo(element.endCoords.x + 15, graphHeight - element.endCoords.y);
    });

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

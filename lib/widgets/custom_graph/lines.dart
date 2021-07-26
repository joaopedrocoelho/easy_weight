import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DrawLines extends StatefulWidget {
  final Coordinates lineCoordinates;
  final double graphHeight;
  final double graphWidth;

  DrawLines({required this.lineCoordinates, required this.graphHeight, required this.graphWidth});

  @override
  _DrawLinesState createState() => _DrawLinesState();
}

class _DrawLinesState extends State<DrawLines> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: LinePainter(
          coordinates: widget.lineCoordinates, graphHeight: widget.graphHeight, graphWidth: widget.graphHeight),
    );
  }
}

class CoordValues {
  late double x;
  late double y;

  CoordValues({required this.x, required this.y});
}

class Coordinates {
  late CoordValues startCoords;
  late CoordValues endCoords;

  Coordinates({required this.startCoords, required this.endCoords});
}

class LinePainter extends CustomPainter {
  late Coordinates coordinates;
  late double graphHeight;
  late double graphWidth;

  LinePainter({required this.coordinates, required this.graphWidth, required this.graphHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF295AE3)
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(graphWidth, 0),
        [
          Color(0xFF12c2e9),
          Color(0xFFc471ed),
          Color(0xFFf64f59)
        ],
        [
          0,
          0.6,
          1
        ]
      )
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    //curved
    /*  Path path = Path();

    path.moveTo(
        coordinates.startCoords.x + 15, graphHeight - coordinates.startCoords.y);
    path.quadraticBezierTo(
        ((coordinates.endCoords.x + 15) - coordinates.startCoords.x) * 2,
        (coordinates.endCoords.y - coordinates.startCoords.y) / 8,
        coordinates.endCoords.x + 15,
        graphHeight - coordinates.endCoords.y);
 */
    //for every two points one line is drawn

    canvas.drawLine(
      //the 15 is to center the lines with the spots after adding the weight labels.
      Offset(
          coordinates.startCoords.x + 15, graphHeight - coordinates.startCoords.y),
      Offset(coordinates.endCoords.x + 15, graphHeight - coordinates.endCoords.y),
      paint,
    );

    //canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

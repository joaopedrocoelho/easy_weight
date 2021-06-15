import 'package:flutter/material.dart';

class DrawLines extends StatefulWidget {
  final Coordinates lineCoordinates;
  final double yHeight;

  DrawLines({required this.lineCoordinates, required this.yHeight});

  @override
  _DrawLinesState createState() => _DrawLinesState();
}

class _DrawLinesState extends State<DrawLines> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: LinePainter(
          coordinates: widget.lineCoordinates, yHeight: widget.yHeight),
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
  late double yHeight;

  LinePainter({required this.coordinates, required this.yHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    //curved
    /* Path path = Path();

    path.moveTo(coordinates.startCoords.x, yHeight - coordinates.startCoords.y);
    path.quadraticBezierTo(
        (coordinates.startCoords.x + coordinates.endCoords.x) / 2,
        coordinates.startCoords.y,
        coordinates.endCoords.x,
        yHeight - coordinates.endCoords.y); */
    //for every two points one line is drawn

    canvas.drawLine(
      //the 15 is to center the lines with the spots after adding the weiggh labels.
      Offset(
          coordinates.startCoords.x + 15, yHeight - coordinates.startCoords.y),
      Offset(coordinates.endCoords.x + 15, yHeight - coordinates.endCoords.y),
      paint,
    );

    //canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

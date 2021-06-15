import 'package:flutter/material.dart';

class DrawHorizontalLines extends StatefulWidget {
  final double lineHeight;
  final double graphWidth;

  DrawHorizontalLines({required this.lineHeight, required this.graphWidth});

  @override
  _DrawHorizontalLinesState createState() => _DrawHorizontalLinesState();
}

class _DrawHorizontalLinesState extends State<DrawHorizontalLines> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: LinePainter(
          lineHeight: widget.lineHeight, graphWidth: widget.graphWidth),
    );
  }
}

class LinePainter extends CustomPainter {
  late double lineHeight;
  late double graphWidth;

  LinePainter({required this.lineHeight, required this.graphWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 2;

    //for every two points one line is drawn

    canvas.drawLine(
      //the 15 is to center the lines with the spots after adding the weiggh labels.
      Offset(0, lineHeight),
      Offset(graphWidth, lineHeight),
      paint,
    );

    //canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

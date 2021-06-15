import 'package:flutter/material.dart';

class GraphSpot extends StatefulWidget {
  final double x;
  final double y;
  final String date;
  final double weight;

  GraphSpot(
      {required this.x,
      required this.y,
      required this.date,
      required this.weight});

  @override
  _GraphSpotState createState() => _GraphSpotState();
}

class _GraphSpotState extends State<GraphSpot> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.x - 5, //minus half of the width of the spot to center
      bottom: widget.y - 5, //minus half of the height of the spot to center
      child: GestureDetector(
        onTap: () {
          print("date: ${widget.date}");
          print("weight: ${widget.weight}");
        },
        child: Column(
          children: [
            Container(
              width: 40,
              decoration: new BoxDecoration(
                color: Colors.lightGreen,
                shape: BoxShape.rectangle,
              ),
              child: Text(widget.weight.toStringAsFixed(1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: new BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            )
          ],
        ),
      ),
    );
  }
}

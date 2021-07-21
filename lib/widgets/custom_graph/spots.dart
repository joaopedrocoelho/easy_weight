import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:new_app/models/button_mode.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:provider/provider.dart';

class GraphSpot extends StatefulWidget {
  final double x;
  final double y;
  final DateTime date;
  final double weight;
  final String note;
  final int id;
  final bool selected;
  final void Function(int listIndex) onGraphSpotTap;

  GraphSpot(
      {required this.x,
      required this.y,
      required this.date,
      required this.weight,
      required this.note,
      required this.id,
      required this.selected,
      required this.onGraphSpotTap});

  @override
  _GraphSpotState createState() => _GraphSpotState();
}

class _GraphSpotState extends State<GraphSpot> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonMode>(
      builder: (context, mode, child) {
        return Positioned(
          left: widget.x - 5, //minus half of the width of the spot to center
          bottom: widget.y -
              12, //minus half of the height of the spot and padding to center
          child: GestureDetector(
            onTap: () {
              widget.onGraphSpotTap(widget.id);
              !widget.selected
                  ? mode.setEditing(WeightRecord(
                      date: widget.date,
                      weight: widget.weight,
                      note: widget.note))
                  : mode.setAdd();
            },
            child: Column(
              children: [
                Neumorphic(
                  style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                    color: Color(0xFF12A3F8),
                    depth: 2,
                    intensity: 0.8,


                  ),
                  child: Container(
                    width: 40,
                                       child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(widget.weight.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: widget.selected
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(width: 4, color: Color(0xFF1EBAE3)),
                        )
                      : BoxDecoration(shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                         boxShape: NeumorphicBoxShape.circle(),
                         color: Color(0xFF12A3F8),
                         shape: NeumorphicShape.convex,
                         intensity: 0.8,
                         depth:3
                      ),
                     

                      child: Container(
                        width: 12,
                        height: 12,
                       
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

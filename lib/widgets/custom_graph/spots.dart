import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/utils/convert_unit.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/button_mode.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:provider/provider.dart';

class GraphSpot extends StatefulWidget {
  final double x;
  final double y;
  final double bottomTitlesHeight;
  final DateTime date;
  final double weight;
  final String note;
  final int id;
  final bool selected;
  final void Function(int listIndex, BuildContext context) onGraphSpotTap;

  GraphSpot(
      {required this.x,
      required this.y,
      required this.bottomTitlesHeight,
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
    String weightToPound = kgToLbs(widget.weight).toStringAsFixed(1);

    return Consumer3<ButtonMode, WeightUnit, ProfilesListModel>(
      builder: (context, mode, unit, profilesList, child) {
        bool _selected = widget.id == mode.selectedIndex ? true : false;

        return Positioned(
          left: widget.x - 5, //minus half of the width of the spot to center
          bottom: widget.y -
              12 +
              widget
                  .bottomTitlesHeight, //minus half of the height of the spot and padding to center
          child: GestureDetector(
            onTap: () {
              mode.onGraphSpotTap(widget.id);
              

              !_selected
                  ? mode.setEditing(WeightRecord(
                      date: widget.date,
                      weight: widget.weight,
                      note: widget.note,
                      profileId: profilesList.selectedProfileID))
                  : mode.setAdd();
            },
            child: Column(
              children: [
                Neumorphic(
                  style: NeumorphicStyle(
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                    color: Color(0xFF12A3F8),
                    depth: 2,
                    intensity: 0.8,
                  ),
                  child: Container(
                    width: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                          unit.usePounds
                              ? weightToPound
                              : widget.weight.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: _selected
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
                          depth: 3),
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

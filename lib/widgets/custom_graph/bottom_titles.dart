import 'package:flutter/material.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/utils/render_graph.dart';
import 'package:new_app/utils/indexed_iterables.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BottomTitles extends StatefulWidget {
  final List<WeightRecord> records;
  final double xWidth;

  const BottomTitles({Key? key, required this.records, required this.xWidth})
      : super(key: key);

  @override
  _BottomTitlesState createState() => _BottomTitlesState();
}

class _BottomTitlesState extends State<BottomTitles> {
  @override
  Widget build(BuildContext context) {
    //display only every other date
    List<Widget> renderBottomTitles() {
      List<DateTime> recordDates =
          widget.records.map((record) => record.date).toList();

      List<DateTime> removedOddDates = removeOdds(recordDates);

      List<Widget> bottomTitles = removedOddDates.mapIndexed((evenDate, index) {
        String date = DateFormat('MM/dd').format(evenDate);

        return Positioned(
          left: (index * 100),
          child: Text(
            "$date",
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        );
      }).toList();

      return bottomTitles;
    }

    return Container(
      width: widget.xWidth,
      height: 30,
      child: Stack(
        children: renderBottomTitles(),
      ),
    );
  }
}

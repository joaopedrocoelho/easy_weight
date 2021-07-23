import 'package:flutter/material.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/widgets/custom_graph/bottom_titles.dart';

class BottomTitlesRow extends StatelessWidget {
  final List<WeightRecord> records;
  final double graphWidth;
  final double bottomTitlesHeight;

  const BottomTitlesRow({
    Key? key,
    required this.records,
    required this.graphWidth,
    required this.bottomTitlesHeight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* SizedBox(width: MediaQuery.of(context).size.width / 10), */
          Container(
            color: Colors.amber,
            width: MediaQuery.of(context).size.width * 0.9,
            child: BottomTitles(records: records, 
            graphWidth: graphWidth, 
            height: bottomTitlesHeight),
          ),
        ],
      ),
    );
  }
}

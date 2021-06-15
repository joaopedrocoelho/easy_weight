import 'package:flutter/material.dart';
import 'package:new_app/utils/database.dart';
import 'package:new_app/utils/format_weight.dart';
import 'package:new_app/utils/indexed_iterables.dart';
import 'package:new_app/utils/render_horizontal_lines.dart';

class SideTitles extends StatefulWidget {
  final List<Map<String, dynamic>> records;
  final double yHeight;

  SideTitles({required this.records, required this.yHeight});

  @override
  _SideTitlesState createState() => _SideTitlesState();
}

class _SideTitlesState extends State<SideTitles> {
  late List<Widget> titles;
  late int minWeight;
  late int maxWeight;
  late int fator;
  late int paddingTop;
  late int paddingBottom;
  late double yPxPerKg;

  @override
  void initState() {
    minWeight = findMinWeight(widget.records).toInt();
    maxWeight = findMaxWeight(widget.records).toInt();
    fator = ((maxWeight - minWeight) / 6).ceil();
    paddingTop = fator;
    paddingBottom =
        ((fator - minWeight).ceil() > 10) ? (fator - minWeight).ceil() : 10;

    yPxPerKg = widget.yHeight /
        ((maxWeight + paddingTop) - (minWeight - paddingBottom));

    // add extra space on the top of the graph;
    titles = renderweights();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue),
      child: Stack(
        children: titles,
      ),
    );
  }

//render 6 titles fazendo uma media entre o
// menor peso( +padding) e o maior peso(+ padding)

  List<Widget> renderweights() {
    List<int> weights = [];

    for (int i = minWeight; i <= maxWeight + paddingTop; i += fator) {
      weights.add(i);
    }

    //weights.add(maxWeight);

    List<Widget> titles = weights.mapIndexed((weight, index) {
      print("weight : ${weights[index]}");
      print("yPos : ${yPos(weights[index].toDouble()) + 10}");

      return Positioned(
        bottom: yPos(weights[index].toDouble()) - 7,
        child: Text(weight.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                backgroundColor: Colors.red)),
      );
    }).toList();

    return titles;
  }

  double yPos(double weight) {
    double result = (weight - (minWeight - paddingBottom)) * yPxPerKg;
    //print('yPos: $result');
    return limitDecimals(result, 2);
  }

  //add the Y coordinates
  List<Map<String, dynamic>> addYPos() {
    List<Map<String, dynamic>> spotsYPos =
        makeModifiableResults(widget.records);
    int getMinWeightIndex = minWeightIndex(widget.records);
    int paddingBottom = 10;

    spotsYPos.forEachIndexed((record, index) {
      if (index == getMinWeightIndex) {
        record['yPos'] = paddingBottom +
            5.0; //because of the centering in the spots widget we need to add 5
        //print('MinWeightIndex: $record');
      } else {
        record['yPos'] = yPos(record['weight']);
        //print("otherRecords: $record");
      }
    });

    return spotsYPos;
  }
}

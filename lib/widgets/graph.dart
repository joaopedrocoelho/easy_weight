import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:new_app/models/records.dart';
import 'package:new_app/utils/format_date.dart';

class Graph extends StatefulWidget {
  final List<FlSpot> chartPoints;
  final List<Map> records;
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  late List<int> weights;

  Graph({required this.chartPoints, required this.records});

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  int touchedIndex = -1;

  List<ShowingTooltipIndicators> selectedSpots = [];

  int findMinWeight() {
    List<int> weights = widget.records.map<int>((record) {
      return record['weight'].toInt();
    }).toList();

    int minWeight = findMin(weights);

    return minWeight;
  }

  int findMaxWeight() {
    List<int> weights = widget.records.map<int>((record) {
      return record['weight'].toInt();
    }).toList();

    int maxWeight = findMax(weights);

    return maxWeight;
  }

  int findMin(List<int> numbers) {
    return numbers.reduce(min);
  }

  int findMax(List<int> numbers) {
    return numbers.reduce(max);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        //the width needs to be fixed
        width: MediaQuery.of(context).size.width * 2,
        height: MediaQuery.of(context).size.height / 2,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(
              LineChartData(
                //need to find the lowest record and add some padding
                maxY: (findMaxWeight() + 10),
                minY: (findMinWeight() -
                    10), //make a function that finds the lowest weight and subtracts 10
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.deepOrange[50],
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    colors: widget.gradientColors,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      colors: widget.gradientColors
                          .map((color) => color.withOpacity(0.3))
                          .toList(),
                    ),
                    spots: widget.chartPoints,
                  )
                ],
                titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 10,
                      getTextStyles: (value) => const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                      getTitles: (value) {
                        // value is equal to the index of the record in records list.
                        return formatDate(
                            widget.records[value.toInt()][RecordFields.date]);
                      },
                      margin: 8,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      getTitles: (value) {
                        return value.toInt().toString();
                      },
                      interval: 5,
                      reservedSize: 28,
                      margin: 12,
                    )),
                showingTooltipIndicators: selectedSpots,
              ),
            )),
      ),
    );
  }
}

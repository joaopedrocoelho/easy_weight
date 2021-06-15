import 'package:flutter/material.dart';
import 'package:new_app/utils/database.dart';
import 'package:new_app/utils/format_date.dart';
import 'package:new_app/utils/format_weight.dart';
import 'package:new_app/utils/render_horizontal_lines.dart';
import 'package:new_app/utils/render_lines.dart';
import 'package:new_app/utils/render_spots.dart';
import 'package:new_app/widgets/custom_graph/horizontal_lines.dart';
import 'package:new_app/widgets/custom_graph/lines.dart';
import 'package:new_app/widgets/custom_graph/spots.dart';
import 'package:new_app/widgets/custom_graph/side_titles.dart';
import 'package:provider/provider.dart';

class MyGraph extends StatefulWidget {
  final List<Map<String, dynamic>> records;
  final double scaleX;
  final double scaleY;

  MyGraph({required this.records, required this.scaleX, required this.scaleY});

  @override
  _MyGraphState createState() => _MyGraphState();
}

class _MyGraphState extends State<MyGraph> {
  late double widthBase;
  late double heightBase;
  late double minWeight;
  late int getMinWeightIndex;
  late int getMaxWeightIndex;
  late double yHeight;
  late double xWidth;
  late List<GraphSpot> spots;
  late List<DrawLines> lines;
  late List<DrawHorizontalLines> horizontalGuidelines;
  late List<Widget> graph;
  late Coordinates demoLine;

  double showDaysInBetween() {
    DateTime date1 = DateTime.parse(widget.records[0]['record_date']);
    DateTime date2 = DateTime.parse(widget.records.last['record_date']);

    int daysInBetween = daysBetween(date1, date2);

    return daysInBetween.toDouble();
  }

  @override
  void initState() {
    minWeight = findMinWeight(widget.records);
    getMinWeightIndex = minWeightIndex(widget.records);
    getMaxWeightIndex = maxWeightIndex(widget.records);
    yHeight = widget.scaleY; //need to define scaleY factor

    horizontalGuidelines =
        renderHorizontalLines(widget.records, widget.scaleX + 10, yHeight);
    spots = renderSpots(widget.records, yHeight);
    lines = renderLines(spots, yHeight);
    graph = new List.from(horizontalGuidelines)..addAll(lines)..addAll(spots);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GraphState,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: yHeight,
              width: widget.scaleX / 10,
              child: SideTitles(
                records: widget.records,
                yHeight: yHeight,
              ),
            ),
            Container(
              color: Colors.white,
              width: widget.scaleX + 10,
              height: yHeight,
              child: Stack(
                children: graph,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GraphState extends ChangeNotifier {
  late List<Map<String, dynamic>> records;

//variables
  bool isLoading = false;
  late double widthBase;
  late double heightBase;
  late double minWeight;
  late double maxWeight;
  late int getMinWeightIndex;
  late int getMaxWeightIndex;
  late int fator;
  late int paddingTop;
  late int paddingBottom;
  late double yPxPerKg;
  late double yHeight;
  late double xWidth;

//load records and set initial values
  void initRecords() async {
    records = await RecordsDatabase.instance.getRecords();
  }
}

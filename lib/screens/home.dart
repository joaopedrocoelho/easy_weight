import 'package:flutter/material.dart';
import 'package:new_app/models/records.dart';
import 'package:new_app/utils/database.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:new_app/widgets/add_record_form.dart';
import 'package:new_app/utils/indexed_iterables.dart';
import 'package:new_app/widgets/custom_graph.dart';
import 'package:new_app/widgets/graph.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Map> records;
  bool isLoading = false;
  late List<FlSpot> chartPoints;

  Future loadRecords() async {
    setState(() => isLoading = true);

    this.records = await RecordsDatabase.instance.getRecords();

    chartPoints = this.records.mapIndexed((record, index) {
      //return points for the graph
      return FlSpot(index.toDouble(), record['weight']);
    }).toList();
    print('load records : $records');
    print('chartPoints: $chartPoints');

    setState(() => isLoading = false);
  }

  void _setVisible() {
    setState(() {
      _animationController.forward();
    });
  }

  void _setinVisible() {
    setState(() {
      _animationController.reverse();
    });
  }

  @override
  void initState() {
    loadRecords();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            isLoading
                ? CircularProgressIndicator()
                : records.isEmpty
                    ? Text(
                        'No Records',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      )
                    : Graph(
                        chartPoints: chartPoints,
                        records: this.records) //buildRecordList(),
          ]),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 30, bottom: 50),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: _setVisible,
              ),
            ),
          ),
          AddRecord(
              animationController: _animationController,
              setVisible: _setVisible,
              setInvisible: _setinVisible,
              setRefresh: loadRecords)
        ]));
  }

  Widget buildRecordList() => ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: records.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              '${records[index][RecordFields.date]} ${records[index][RecordFields.weight]} ${records[index][RecordFields.note]}',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          );
        },
      );

  Widget buildRecordLineChart() => LineChart(LineChartData(
          gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.deepOrange,
                  strokeWidth: 1,
                );
              }),
          lineBarsData: [
            LineChartBarData(
              spots: chartPoints,
            )
          ]));
}

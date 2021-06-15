import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:new_app/utils/database.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:new_app/widgets/add_record_form.dart';

import 'package:new_app/widgets/custom_graph.dart';
import 'package:new_app/utils/format_weight.dart';
import '../globals.dart' as globals;

class HomeCustom extends StatefulWidget {
  @override
  _HomeCustomState createState() => _HomeCustomState();
}

class _HomeCustomState extends State<HomeCustom>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Map<String, dynamic>> records;
  bool isLoading = false;
  late List<FlSpot> chartPoints;

  Future loadRecords() async {
    setState(() => isLoading = true);

    this.records = await RecordsDatabase.instance.getRecords();

    /* globals.records = this.records;
      
    globals.minWeight = findMinWeight(globals.records);
    globals.maxWeight = findMaxWeight(globals.records);
    globals.getMinWeightIndex = minWeightIndex(globals.records);
    globals.getMaxWeightIndex = maxWeightIndex(globals.records);
    globals.yHeight = ;
    globals.fator = ((maxWeight - minWeight) / 6).ceil();
    globals.paddingTop = fator;
    globals.paddingBottom =
        ((fator - minWeight).ceil() > 10) ? (fator - minWeight).ceil() : 10;

    globals.yPxPerKg = widget.yHeight /
        ((maxWeight + paddingTop) - (minWeight - paddingBottom)); */

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
        Center(
            child: isLoading
                ? CircularProgressIndicator()
                : records.isEmpty
                    ? Text(
                        'No Records',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      )
                    : MyGraph(
                        records: this.records,
                        scaleX: MediaQuery.of(context).size.width *
                            (records.length / 8),
                        scaleY: MediaQuery.of(context).size.height / 2)),
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
      ]),
    );
  }
}

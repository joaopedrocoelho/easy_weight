import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/utils/render_graph.dart';
import 'package:easy_weight/utils/indexed_iterables.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BottomTitles extends StatefulWidget {
  final List<WeightRecord> records;
  final double graphWidth;
  final double height;

  const BottomTitles(
      {Key? key,
      required this.records,
      required this.graphWidth,
      required this.height})
      : super(key: key);

  @override
  _BottomTitlesState createState() => _BottomTitlesState();
}

class _BottomTitlesState extends State<BottomTitles> {
  String formatDate(DateTime date) {
    return Platform.localeName == 'en_US'
        ? DateFormat.Md().format(date)
        : DateFormat('dd/MM').format(date);
        
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    //display only every other date
    List<Widget> renderBottomTitles() {
      List<DateTime> recordDates =
          widget.records.map((record) => record.date).toList();

      List<DateTime> removedOddDates = removeOdds<DateTime>(recordDates);

      List<Widget> bottomTitles = removedOddDates.mapIndexed((evenDate, index) {
        String date = formatDate(evenDate);

        return Positioned(
          left: (index * 100),
          child: Text(
            "$date",
            style: theme.textTheme.caption,
          ),
        );
      }).toList();

      return bottomTitles;
    }

    List<Widget> bottomTitles = renderBottomTitles();

    return Container(
      width: widget.graphWidth,
      height: 30,
      child: Stack(
        children: renderBottomTitles(),
      ),
    );
  }
}

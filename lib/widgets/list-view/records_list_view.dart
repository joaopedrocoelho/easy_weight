import 'package:flutter/material.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/widgets/list-view/record_list_button.dart';
import 'package:new_app/utils/indexed_iterables.dart';

class RecordsListView extends StatefulWidget {
  const RecordsListView({required this.records});

  final List<WeightRecord> records;

  @override
  _RecordsListViewState createState() => _RecordsListViewState();
}

class _RecordsListViewState extends State<RecordsListView> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    List<Widget> recordsWidgetList = widget.records
        .mapIndexed((record, index) => RecordListButton(
              date: record.date,
              weight: record.weight,
              note: record.note,
              id: index,
              selected: index == _selectedIndex ? true : false,
              onGraphSpotTap: () {
                setState(() {
                  _selectedIndex == index
                      ? _selectedIndex = null
                      : _selectedIndex = index;
                });
              },
            ))
        .toList();

    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: recordsWidgetList,
            )));
  }
}

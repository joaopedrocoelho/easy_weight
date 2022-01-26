import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:easy_weight/models/button_mode.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/utils/format_date.dart';

import 'package:provider/provider.dart';

typedef void SetDate(DateTime date);

class NeuDatePicker extends StatefulWidget {
  final SetDate callback;
  final DateTime currentDate;
  final List<WeightRecord> records;
  final List<DateTime> usedDates;
  final String selectedDate;

  NeuDatePicker(
      {required this.callback,
      required this.currentDate,
      required this.records,
      required this.usedDates,
      required this.selectedDate});

  @override
  _NeuDatePickerState createState() => _NeuDatePickerState();
}

class _NeuDatePickerState extends State<NeuDatePicker> {
  Future<Null> _selectDate(BuildContext context, List<DateTime> usedDates,
      DateTime initialDate) async {
    dynamic _datePicker = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        selectableDayPredicate: (date) {
          //print('usedDates from _selectDate:$usedDates');
          return usedDates.contains(date) ? false : true;
        });

    if (_datePicker != null) {
      setState(() {
        widget.callback(
          _datePicker,
        );
      });
    }
  }

  @override
  void initState() {
    print("selectedDate: ${widget.selectedDate}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    final bodyText1 = theme.textTheme.bodyText1;

    return Consumer<RecordsListModel>(
      builder: (context, records, child) {
        return NeumorphicButton(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
                  depth: -3,
                  intensity: 0.9,
                ),
                padding:
                    EdgeInsets.only(top: 14.0, left: 18, right: 14, bottom: 18),
                onPressed: () {
                  _selectDate(
                      context, widget.usedDates, records.lastAvailableDate);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      records.formattedCurrentDate,
                      style: bodyText1?.copyWith(fontSize: 16),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: theme.defaultTextColor,
                    ),
                  ],
                ))       
            ;
      },
    );
  }
}

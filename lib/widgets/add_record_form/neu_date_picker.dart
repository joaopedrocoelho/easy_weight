import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:new_app/models/button_mode.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:provider/provider.dart';
  

typedef void SetDate(DateTime date);

class NeuDatePicker extends StatefulWidget {
  final SetDate callback;
  final DateTime currentDate;

  NeuDatePicker({required this.callback, required this.currentDate});

  @override
  _NeuDatePickerState createState() => _NeuDatePickerState();
}

class _NeuDatePickerState extends State<NeuDatePicker> {
  late String _formattedNow;
  late DateTime _currentDate;
  late String _formattedCurrentDate;
  late List<DateTime> _usedDates;
  bool _isDisabled = false;

  List<DateTime> getUsedDates(List<WeightRecord> records) {
    List<DateTime> usedDates = [];
    if (records.isNotEmpty) {
      records.forEach((record) => {usedDates.add(record.date)});
    }
    return usedDates;
  }

  Future<Null> _selectDate(
      BuildContext context, List<DateTime> usedDates) async {
    dynamic _datePicker = await showDatePicker(
        context: context,
        initialDate: _currentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        selectableDayPredicate: (date) {
          usedDates.remove(
            _currentDate,
          );
          print("usedDates: $usedDates");
          return usedDates.contains(date) ? false : true;
        });

    if (_datePicker != null && _datePicker != _currentDate) {
      setState(() {
        _currentDate = _datePicker;
        _formattedNow = DateFormat('MM/dd').format(
          _currentDate,
        );
        widget.callback(
          _currentDate,
        );
      });
    }
  }

  @override
  void initState() {
    _currentDate = DateTime(widget.currentDate.year, widget.currentDate.month,
        widget.currentDate.day);
    _formattedCurrentDate = DateFormat('MM/dd').format(
      _currentDate,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    final bodyText1 = theme.textTheme.bodyText1;

    return Consumer<ButtonMode>(
      builder: (context, mode, child) {
        return NeumorphicButton(
            style :NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
          depth: -3,
          intensity: 0.9,
          
        ),
        padding:EdgeInsets.only(top:14.0, left:18, right: 14, bottom:18),
        onPressed: mode.isEditing
                ? null
                : () {
                    _selectDate(context, []);
                  },
        child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_formattedCurrentDate',
                  style: bodyText1?.copyWith(fontSize: 16),
                ),
                Icon(
                  Icons.calendar_today,
                  color: theme.defaultTextColor,
                ),
              ],
            )

        )
        
        
        /* TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.grey, width: 0.0))),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(16.0)),
            ),
            onPressed: mode.isEditing
                ? null
                : () {
                    _selectDate(context, []);
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_formattedCurrentDate',
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
              ],
            )) */;
      },
    );
  }
}

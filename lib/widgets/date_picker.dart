import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef void SetDate(DateTime date);

class DatePicker extends StatefulWidget {
  final SetDate callback;

  DatePicker(this.callback);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _currentDate = DateTime.now();
  String _formattedNow = DateFormat('MM/dd').format(DateTime.now());

  Future<Null> _selectDate(BuildContext context) async {
    dynamic _datePicker = await showDatePicker(
        context: context,
        initialDate: _currentDate,
        firstDate: DateTime(1990),
        lastDate: DateTime.now());

    if (_datePicker != null && _datePicker != _currentDate) {
      setState(() {
        _currentDate = _datePicker;
        _formattedNow = DateFormat('MM/dd').format(_currentDate);
        widget.callback(_currentDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.grey, width: 0.0))),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(16.0)),
        ),
        onPressed: () {
          _selectDate(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_formattedNow',
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
          ],
        ));
  }
}

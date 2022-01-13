import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:easy_weight/models/button_mode.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/utils/format_date.dart';

import 'package:provider/provider.dart';

typedef void SetDate(DateTime date);

class NeuBirthdayPicker extends StatefulWidget {
  

  NeuBirthdayPicker(
      );

  @override
  _NeuBirthdayPickerState createState() => _NeuBirthdayPickerState();
}

class _NeuBirthdayPickerState extends State<NeuBirthdayPicker> {
  Future<Null> _selectDate(BuildContext context) async {
    dynamic _datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
       );
    if (_datePicker != null) {  
      return _datePicker;
    }
   
  }

  @override
  void initState() {
    

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
                      context);
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

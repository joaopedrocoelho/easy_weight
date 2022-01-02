import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class EditDateForm extends StatelessWidget {
  final DateTime date;

  const EditDateForm({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    final bodyText1 = theme.textTheme.bodyText1;
    String _formattedCurrentDate = DateFormat('MM/dd').format(date);

    return NeumorphicButton(
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
            //color: theme.defaultTextColor,

            depth: 5,
            intensity: 1,
            surfaceIntensity: 0.1),
        padding: EdgeInsets.only(top: 14.0, left: 18, right: 14, bottom: 18),
        onPressed: null,
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
        ));
  }
}

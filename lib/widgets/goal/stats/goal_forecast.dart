
// not sure if I'll do this
/* import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:provider/provider.dart';



class WeightTrend extends StatelessWidget {
  final double? number;
  final String stat;

  const WeightTrend({Key? key, required this.number, required this.stat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

 

    return Consumer<WeightUnit>(builder: (context, unit, child) {
      String numberToPound = 
      number != null ?
      (number! * 2.20462).toStringAsFixed(1) :
      '0.0lb';


      Text statTextKg = stat != null
          ? Text('${variation! > 0 ? '+' : ''}${variation.toString()}kg',
              style: theme.textTheme.subtitle2?.copyWith(height: 1))
          : Text('0.0kg',
              style: theme.textTheme.subtitle2?.copyWith(height: 1));

      Text statTextPound = stat  != null
          ? Text('${variation! > 0 ? '+' : ''}${variationToPound}lb',
              style: theme.textTheme.subtitle2?.copyWith(height: 1))
          : Text('0.0lb',
              style: theme.textTheme.subtitle2?.copyWith(height: 1));

      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(stat, style: theme.textTheme.caption),
           
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: unit.usePounds ? variationTextPound : variationTextKg,
            )
          ],
        ),
      );
    });
  }
}
 */
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:new_app/widgets/stats/big_weight_headline.dart';
import 'package:new_app/widgets/stats/weight_trend.dart';

class CurrentWeightStats extends StatelessWidget {
  const CurrentWeightStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);


    return Padding(
      padding: const EdgeInsets.only(left:20.0, right: 20.0, bottom:20.0, top:10),
      child: Container(
        
        child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              
              Text('Current', style: theme.textTheme.caption),
              BigWeightHeadline(weight: 80.5),
             
              WeightTrend(variation: -0.5, period: 'Week'),
        
              WeightTrend(variation: 5.5, period: 'Month')
              ]),
             
            
          
        ),
      
    );
  }
}
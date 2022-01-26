import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/widgets/stats/big_weight_headline.dart';
import 'package:easy_weight/widgets/stats/weight_trend.dart';

class CurrentWeightStats extends StatelessWidget {
  final double? currentWeight;
  final double? weekTrend;
  final double? monthTrend;
  final double? allTimeTrend;

  const CurrentWeightStats(
      {Key? key,
      required this.currentWeight,
      required this.weekTrend,
      required this.monthTrend,
      required this.allTimeTrend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 10),
      child: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Text('Current', style: theme.textTheme.caption),
              ),
              BigWeightHeadline(weight: currentWeight),
              WeightTrend(variation: weekTrend, period: 'Week'),
              WeightTrend(variation: monthTrend, period: 'Month'),
              WeightTrend(variation: allTimeTrend, period: 'Total')
            ]),
      ),
    );
  }
}

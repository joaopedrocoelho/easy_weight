import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

double renderPadding(String period) {
  double padding = 0.0;
  switch (period) {
    case 'Month':
      padding = 8.0;
      break;

    case 'Week':
      padding = 15.0;
      break;
    case 'Total':
      padding = 17.0;
      break;
  }

  return padding;
}

class WeightTrend extends StatelessWidget {
  final double variation;
  final String period;

  const WeightTrend({Key? key, required this.variation, required this.period})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    

    Icon setIcon(double variation) {
      if (variation > 0) {
        return Icon(Icons.trending_up_rounded,
            size: 30, color: Color(0xffe8407a));
      } else if (variation == 0) {
        return Icon(Icons.trending_flat_rounded,
            size: 30, color: theme.defaultTextColor);
      } else {
        return Icon(Icons.trending_down_rounded,
            size: 30, color: Color(0xff3bd655));
      }
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(period, style: theme.textTheme.caption),
          Padding(
            padding: EdgeInsets.only(left: renderPadding(period)),
            child: setIcon(variation),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text('${variation > 0 ? '+' : ''}${variation.toString()}kg',
                style: theme.textTheme.subtitle2?.copyWith(height: 1)),
          )
        ],
      ),
    );
  }
}

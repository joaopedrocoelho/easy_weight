import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:new_app/models/records_model.dart';
import 'package:new_app/models/weight_unit.dart';
import 'package:new_app/models/goal_model.dart';
import 'package:new_app/utils/format_weight.dart';
import 'package:new_app/utils/render_stats.dart';
import 'package:provider/provider.dart';

class RemainingGoalText extends StatelessWidget {
  final Goal goal;
  final double currentWeight;
  final bool usePounds;

  const RemainingGoalText(
      {Key? key,
      required this.goal,
      required this.currentWeight,
      required this.usePounds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    return Consumer<WeightUnit>(
      builder: (context, unit, child) {
        double _remaining = (currentWeight - goal.weight) > 0
            ? limitDecimals((currentWeight - goal.weight), 1)
            : limitDecimals(-(currentWeight - goal.weight), 1);

        String remainingToPound = (_remaining * 2.20462).toStringAsFixed(1);

        Text _showRemaining() {
          return unit.usePounds
              ? Text('${remainingToPound}lb',
                  style: theme.textTheme.subtitle2?.copyWith(height: 1))
              : Text('${_remaining}kg',
                  style: theme.textTheme.subtitle2?.copyWith(height: 1));
        }

        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Left', style: theme.textTheme.caption),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: _showRemaining(),
              )
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:easy_weight/models/goal_model.dart';
import 'package:provider/provider.dart';

class CurrentGoalText extends StatelessWidget {
  final Goal? goal;

  final bool usePounds;

  const CurrentGoalText({Key? key, required this.goal, required this.usePounds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    String goalToPound =
        goal != null ? (goal!.weight * 2.20462).toStringAsFixed(1) : '-';

    Text _showGoal() {
      if (goal != null) {
        return usePounds
            ? Text('$goalToPound',
                style: theme.textTheme.subtitle2?.copyWith(height: 1))
            : Text('${goal!.weight}',
                style: theme.textTheme.subtitle2?.copyWith(height: 1));
      } else {
        return Text('-', style: theme.textTheme.subtitle2?.copyWith(height: 1));
      }
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Goal', style: theme.textTheme.caption),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: _showGoal(),
          )
        ],
      ),
    );
  }
}

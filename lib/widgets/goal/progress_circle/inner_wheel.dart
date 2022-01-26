import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/utils/render_stats.dart';
import 'package:easy_weight/widgets/goal/progress_circle/goal_percentage.dart';
import 'package:easy_weight/models/goal_model.dart';
import 'package:easy_weight/widgets/goal/set_goal_button.dart';
import 'package:provider/provider.dart';

class InnerWheel extends StatelessWidget {
  const InnerWheel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

    List<WeightRecord> records = context.watch<RecordsListModel>().records;
    double _currentWeight = renderCurrentWeight(records)!;

    return Consumer<GoalModel>(builder: (context, goalModel, child) {
      return Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.shadowDarkColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                offset: Offset(-5, -5),
                color: theme.shadowLightColor.withOpacity(0.5),
              ),
              BoxShadow(
                  blurRadius: 15,
                  offset: Offset(8, 8),
                  color: theme.shadowDarkColor.withOpacity(0.9))
            ],
          ),
          child: goalModel.currentGoal != null
              ? GoalPercentage(
                  initialWeight: goalModel.currentGoal!.initialWeight,
                  currentWeight: _currentWeight,
                  goal: goalModel.currentGoal!.weight)
              : SetGoalButton());
    });
  }
}

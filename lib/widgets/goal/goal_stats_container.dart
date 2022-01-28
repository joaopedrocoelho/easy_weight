
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_unit.dart';

import 'package:easy_weight/utils/render_stats.dart';
import 'package:easy_weight/widgets/goal/goal_circle.dart';

import 'package:easy_weight/widgets/goal/stats/current_goal_text.dart';
import 'package:easy_weight/widgets/goal/stats/remaining_goal_text.dart';
import 'package:easy_weight/models/goal_model.dart';
import 'package:provider/provider.dart';

class GoalStatsContainer extends StatelessWidget {
  final VoidCallback setVisible;

  const GoalStatsContainer({Key? key, required this.setVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

    return Consumer3<GoalModel, WeightUnit, RecordsListModel>(
        builder: (context, goalModel, unit, records, child) {
      return Padding(
        padding: const EdgeInsets.only(top:10.0,right:4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(onTap: setVisible, child: GoalCircle()),
            SizedBox(
              height: 10,
            ),
            FractionallySizedBox(
              alignment: Alignment.center,
              widthFactor: 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CurrentGoalText(
                    goal: goalModel.currentGoal,
                    usePounds: unit.usePounds,
                  ),
                  Spacer(),
                  if (goalModel.currentGoal != null)
                    RemainingGoalText(
                      goal: goalModel.currentGoal!,
                      currentWeight: renderCurrentWeight(records.records)!,
                      usePounds: unit.usePounds,
                    )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

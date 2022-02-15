
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
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(onTap: setVisible, child: GoalCircle()),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  CurrentGoalText(
                    goal: goalModel.currentGoal,
                    usePounds: unit.usePounds,
                  ),
                  SizedBox(width: 10,),
                  if (goalModel.currentGoal != null)
                    RemainingGoalText(
                      goal: goalModel.currentGoal!,
                      currentWeight: renderCurrentWeight(records.records)?? 0,
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

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/goal_model.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/utils/format_weight.dart';
import 'package:easy_weight/utils/render_stats.dart';
import 'package:easy_weight/widgets/goal/progress_circle/inner_wheel.dart';
import 'package:easy_weight/widgets/goal/progress_circle/progress_painter.dart';
import 'package:provider/provider.dart';

class OuterWheel extends StatelessWidget {
  const OuterWheel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

    return Consumer2<GoalModel, RecordsListModel>(
        builder: (context, goal, records, child) {
      List<WeightRecord> records = context.watch<RecordsListModel>().records;
      double _currentWeight = renderCurrentWeight(records)!;

      int getPercentage(
          double initialWeight, double currentWeight, double goal) {
        double percentage =
            100 * (initialWeight - currentWeight) / (initialWeight - goal);

        return percentage > 0 ? percentage.ceil() : 0;
      }

      return Container(
        height: 148,
        width: 148,
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
            border: Border.all(color: theme.baseColor, width: 8)),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 108,
                height: 108,
                child: CustomPaint(
                  child: Center(),
                  painter: ProgressPainter(
                      gradient: [
                        Color(0xFF12c2e9),
                        Color(0xFFc471ed),
                        //Color(0xFFf64f59)
                      ],
                      completedPercentage: goal.currentGoal != null
                          ? getPercentage(goal.currentGoal!.initialWeight,
                                  _currentWeight, goal.currentGoal!.weight)
                              .toDouble()
                          : 0,
                      circleWidth: 24),
                ),
              ),
            ),
            Center(
              child: InnerWheel(),
            )
          ],
        ),
      );
    });
  }
}

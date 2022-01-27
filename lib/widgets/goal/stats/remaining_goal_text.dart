import 'package:easy_weight/utils/convert_unit.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:easy_weight/models/goal_model.dart';
import 'package:easy_weight/utils/format_weight.dart';

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

        String remainingToPound = kgToLbs(_remaining).toStringAsFixed(1);

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
              Text(AppLocalizations.of(context)!.goalRemaining, style: theme.textTheme.caption),
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

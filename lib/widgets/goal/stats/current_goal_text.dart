
import 'package:easy_weight/utils/convert_unit.dart';
import 'package:easy_weight/utils/logger_instace.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:easy_weight/models/goal_model.dart';


class CurrentGoalText extends StatefulWidget {
  final Goal? goal;

  final bool usePounds;

  const CurrentGoalText({Key? key, required this.goal, required this.usePounds})
      : super(key: key);

  @override
  State<CurrentGoalText> createState() => _CurrentGoalTextState();
}

class _CurrentGoalTextState extends State<CurrentGoalText> {
  late String goalToPound; 

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);


    goalToPound =
        widget.goal != null ? kgToLbs(widget.goal!.weight).toStringAsFixed(0) : '-';

    

    Text _showGoal() {
      if (widget.goal != null) {
        return widget.usePounds
            ? Text('$goalToPound',
                style: theme.textTheme.subtitle2?.copyWith(height: 1))
            : Text('${widget.goal!.weight.toStringAsFixed(1)}',
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
          Text(AppLocalizations.of(context)!.goalWeight, style: theme.textTheme.caption),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: _showGoal(),
          )
        ],
      ),
    );
  }
}

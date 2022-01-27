import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/widgets/stats/big_weight_headline.dart';
import 'package:easy_weight/widgets/stats/weight_trend.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top:10.0,left:10,right: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Text(AppLocalizations.of(context)!.currentWeight,
                    style: theme.textTheme.caption),
              ),
              BigWeightHeadline(weight: currentWeight),
              WeightTrend(
                  variation: weekTrend,
                  period: AppLocalizations.of(context)!.weekStat),
              WeightTrend(
                  variation: monthTrend,
                  period: AppLocalizations.of(context)!.monthStat),
              WeightTrend(
                  variation: allTimeTrend,
                  period: AppLocalizations.of(context)!.totalStat)
            ]),
      ),
    );
  }
}

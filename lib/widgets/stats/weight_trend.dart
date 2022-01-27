import 'package:easy_weight/utils/convert_unit.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:provider/provider.dart';

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
  final double? variation;
  final String period;

  const WeightTrend({Key? key, required this.variation, required this.period})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    Icon setIcon(double? variation) {
      if (variation != null && variation > 0) {
        return Icon(Icons.trending_up_rounded,
            size: 30, color: Color(0xffe8407a));
      } else if (variation == 0 || variation == null) {
        return Icon(Icons.trending_flat_rounded,
            size: 30, color: theme.defaultTextColor);
      } else {
        return Icon(Icons.trending_down_rounded,
            size: 30, color: Color(0xff3bd655));
      }
    }

    return Consumer<WeightUnit>(builder: (context, unit, child) {
      String variationToPound = variation != null
          ? kgToLbs(variation!).toStringAsFixed(1)
          : '0.0lb';

      Text variationTextKg = variation != null
          ? Text('${variation! > 0 ? '+' : ''}${variation.toString()}kg',
              style: theme.textTheme.subtitle2?.copyWith(height: 1))
          : Text('0.0kg',
              style: theme.textTheme.subtitle2?.copyWith(height: 1));

      Text variationTextPound = variation != null
          ? Text('${variation! > 0 ? '+' : ''}${variationToPound}lb',
              style: theme.textTheme.subtitle2?.copyWith(height: 1))
          : Text('0.0lb',
              style: theme.textTheme.subtitle2?.copyWith(height: 1));

      return Container(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(period, style: theme.textTheme.caption),
            Spacer(),
            setIcon(variation),
            SizedBox(width: 4,),
            unit.usePounds ? variationTextPound : variationTextKg
          ],
        ),
      );
    });
  }
}

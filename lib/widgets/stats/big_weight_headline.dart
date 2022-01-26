import 'package:easy_weight/utils/convert_unit.dart';
import 'package:flutter/material.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:provider/provider.dart';

class BigWeightHeadline extends StatelessWidget {
  final double? weight;

  const BigWeightHeadline({Key? key, required this.weight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WeightUnit>(builder: (context, unit, child) {
      String weightKg = weight == null ? '0.0' : weight.toString();

      String weightToPound =
          weight != null ? (kgToLbs(weight!).toStringAsFixed(0)) : '0.0';
          

      return Container(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                unit.usePounds ? weightToPound : weightKg,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 70,
                    fontWeight: FontWeight.w600,
                    textBaseline: TextBaseline.alphabetic,
                    height: 1),
              ),
              Text(unit.usePounds ? 'lb' : 'kg',
                  style: Theme.of(context).textTheme.bodyText1)
            ]),
      );
    });
  }
}

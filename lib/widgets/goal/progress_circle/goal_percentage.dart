
import 'package:flutter_neumorphic/flutter_neumorphic.dart';



int getPercentage(double initialWeight, double currentWeight, double goal) {
  double percentage =
      100 * (initialWeight - currentWeight) / (initialWeight - goal);

  if (percentage >= 100) {
    return 100;
  } else {
    return percentage > 0 ? percentage.ceil() : 0;
  }
}

class GoalPercentage extends StatelessWidget {
  final double initialWeight;
  final double currentWeight;
  final double goal;

  GoalPercentage(
      {Key? key,
      required this.initialWeight,
      required this.currentWeight,
      required this.goal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

    return Neumorphic(
      child: Center(
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              getPercentage(initialWeight, currentWeight, goal).toString(),
              style: theme.textTheme.headline4,
            ),
            Flexible(
              child: Text('%', style: Theme.of(context).textTheme.bodyText1),
            )
          ],
        )),
      ),
      style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          intensity: 0.5,
          surfaceIntensity: 0.5,
          border: NeumorphicBorder(color: theme.baseColor, width: 5),
          depth: 8,
          boxShape: NeumorphicBoxShape.circle()),
    );
  }
}

/* import 'package:flutter/material.dart';
import 'package:new_app/widgets/goal/progress_circle/progress_painter.dart';

class CircleContainer extends StatelessWidget {
  const CircleContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white70),
      child: CustomPaint(
        child: Center(),
        painter: ProgressPainter(
            defaultCircleColor: Colors.blue[400]!,
            percentageCompletedCircleColor: Colors.green[600]!,
            completedPercentage: 50,
            circleWidth: 20),
      ),
    );
  }
}
 */
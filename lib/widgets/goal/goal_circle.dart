import 'package:flutter/material.dart';
import 'package:easy_weight/widgets/goal/progress_circle/outer_wheel.dart';

class GoalCircle extends StatefulWidget {
  GoalCircle({Key? key}) : super(key: key);

  @override
  GoalCircleState createState() => GoalCircleState();
}

class GoalCircleState extends State<GoalCircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: OuterWheel(),
    );
  }
}

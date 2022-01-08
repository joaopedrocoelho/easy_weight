import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:easy_weight/widgets/my_flutter_app_icons.dart';

class SetGoalButton extends StatelessWidget {
  const SetGoalButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    return Container(
      child: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            intensity: 0.5,
            surfaceIntensity: 0.5,
            border: NeumorphicBorder(color: theme.baseColor, width: 5),
            depth: 8,
            boxShape: NeumorphicBoxShape.circle()),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(MyFlutterApp.add_goal,
                size: 50, color: theme.defaultTextColor),
          ],
        )),
      ),
    );
  }
}

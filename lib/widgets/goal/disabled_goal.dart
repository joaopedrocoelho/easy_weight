import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/widgets/goal/stats/current_goal_text.dart';
import 'package:provider/provider.dart';

class DisabledGoal extends StatelessWidget {
  const DisabledGoal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    return Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20.0, top: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
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
                      ),
                    ),
                    Center(
                        child: Container(
                      height: 90,
                      width: 90,
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
                      ),
                      child: Container(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              intensity: 1,
                              surfaceIntensity: 0.5,
                              border: NeumorphicBorder(
                                  color: theme.baseColor, width: 5),
                              depth: 8,
                              boxShape: NeumorphicBoxShape.circle()),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CurrentGoalText(
                      goal: null,
                      usePounds: false,
                    ),
                  ])
            ]));
  }
}

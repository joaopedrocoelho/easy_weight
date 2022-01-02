import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CancelButton extends StatelessWidget {
  final void Function() onPressed;

  const CancelButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    bool isUsingDark = NeumorphicTheme.isUsingDark(context);
    final buttonTheme = theme.textTheme.button;

    return NeumorphicButton(
        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          intensity: 1,
          surfaceIntensity: 0.5,
          depth: 2,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
          // border: NeumorphicBorder(color: Color(0xffE8407A), width: 1.5)
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
              child: Text('CANCEL',
                  style: buttonTheme?.copyWith(
                      color: isUsingDark
                          ? theme.defaultTextColor
                          : Color(0xffE8407A)))),
        ),
        onPressed: onPressed);
  }
}

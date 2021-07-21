import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SaveButton extends StatelessWidget {
  final void Function() onPressed;

  const SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    final shadowLightColor = theme.shadowLightColorEmboss;
    final buttonTheme = theme.textTheme.button;

    return NeumorphicButton(
        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          intensity: 1,
          surfaceIntensity: 0.5,
          depth: 2,
          color: Color(0xff12A3F8),
          shadowLightColorEmboss: Color(0xff12A3F8),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
              child: Text('SAVE',
                  style: buttonTheme
                      ?.copyWith(color: Color(0xffFFFFFF)))),
        ),
        onPressed: onPressed);
  }
}

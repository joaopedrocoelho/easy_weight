import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeuFormContainer extends StatelessWidget {
  final Widget? child;
  double? height;

  NeuFormContainer({Key? key, this.child, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    return Neumorphic(
      padding: EdgeInsets.all(20.0),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        )),
        depth: 5,
        intensity: 0.4,
      ),
      child: Container(
        height: height != null ? height : 420,
        child: child,
      ),
    );
  }
}

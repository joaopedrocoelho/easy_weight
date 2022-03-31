
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeuCloseButton extends StatelessWidget {
  final void Function()? onPressed;

  const NeuCloseButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    return NeumorphicButton(
      onPressed: onPressed,
      padding: EdgeInsets.all(5.0),
      style: NeumorphicStyle(
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.circle(),
        intensity: 1,
        depth: 2,
        surfaceIntensity: 0.7,
      ),
      child: Icon(Icons.close_rounded, size: 15, color: theme.defaultTextColor),
    );

  }
}

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SaveButton extends StatelessWidget {
  final void Function() onPressed;

  const SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    
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
              child: Text(AppLocalizations.of(context)!.saveBtn.toUpperCase(),
                  style: buttonTheme
                      ?.copyWith(color: Color(0xffFFFFFF)))),
        ),
        onPressed: onPressed);
  }
}

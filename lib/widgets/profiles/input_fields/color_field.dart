import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class ColorInputField extends StatefulWidget {
  final Color color;
  ColorInputField({required this.color, Key? key}) : super(key: key);

  @override
  _ColorInputFieldState createState() => _ColorInputFieldState();
}

class _ColorInputFieldState extends State<ColorInputField> {
  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);
    var bodyText1 = theme.textTheme.bodyText1;

    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
        depth: -3,
        intensity: 0.9,
      ),
      padding: EdgeInsets.only(top: 14.0, left: 18, right: 14, bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            toBeginningOfSentenceCase(AppLocalizations.of(context)!.color)!,
            style: bodyText1?.copyWith(fontSize: 16),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.4),
                  border: Border.all(color: theme.defaultTextColor, width: 4),
                  borderRadius: BorderRadius.circular(25)),
              height: 25,
              width: 25,
            ),
          ),
        ],
      ),
    );
  }
}

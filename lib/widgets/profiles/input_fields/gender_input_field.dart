import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:easy_weight/models/profile_model.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';


class GenderInputField extends StatefulWidget {
  final Gender gender;

  const GenderInputField({
    Key? key,
    required this.gender,
  }) : super(key: key);

  @override
  _GenderInputFieldState createState() => _GenderInputFieldState();
}

class _GenderInputFieldState extends State<GenderInputField> {
  //TextEditingController _textController = TextEditingController();

  @override
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    final bodyText1 = theme.textTheme.bodyText1;

    return Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
          depth: -3,
          intensity: 0.9,
        ),
        padding: EdgeInsets.only(top: 10.0, left: 18, right: 28, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.gender,
              style: bodyText1?.copyWith(fontSize: 16),
            ),
            SizedBox(
             
            ),
            Text(
              widget.gender != Gender.undefined ?
              widget.gender.toString().split('.').last[0].toUpperCase() :
              '', style: theme.textTheme.headline5),
          ],
        ));
  }
}

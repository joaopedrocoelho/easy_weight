
import 'package:flutter_neumorphic/flutter_neumorphic.dart';


class NeuGenderPicker extends StatefulWidget {
  final String gender;

  const NeuGenderPicker({
    Key? key,
    required this.gender,
  }) : super(key: key);

  @override
  _NeuGenderPickerState createState() => _NeuGenderPickerState();
}

class _NeuGenderPickerState extends State<NeuGenderPicker> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

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
              "Gender",
              style: bodyText1?.copyWith(fontSize: 16),
            ),
            SizedBox(
             
            ),
            Text(widget.gender, style: theme.textTheme.headline5),
          ],
        ));
  }
}

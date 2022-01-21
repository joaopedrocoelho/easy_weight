import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:provider/provider.dart';

class EmojiInputField extends StatefulWidget {
  final String emoji;

  const EmojiInputField({
    Key? key,
    required this.emoji,
  }) : super(key: key);

  @override
  _EmojiInputFieldState createState() => _EmojiInputFieldState();
}

class _EmojiInputFieldState extends State<EmojiInputField> {
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
              "Emoji",
              style: bodyText1?.copyWith(fontSize: 16),
            ),
            Text(widget.emoji, style: bodyText1?.copyWith(fontSize: 28)),
          ],
        ));
  }
}

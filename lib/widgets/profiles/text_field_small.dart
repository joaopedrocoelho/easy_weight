import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:provider/provider.dart';

class NeuTextFieldMedium extends StatefulWidget {
  final String initialValue;
  final String errorText;
  final String hintText;
  final void Function(String?)? onSaved;
  final FocusNode hintFocus;

  const NeuTextFieldMedium(
      {Key? key,
      required this.initialValue,
      required this.errorText,
      required this.hintText,
      required this.onSaved,
      required this.hintFocus})
      : super(key: key);

  @override
  _NeuTextFieldMediumState createState() => _NeuTextFieldMediumState();
}

class _NeuTextFieldMediumState extends State<NeuTextFieldMedium> {
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

    return Consumer<WeightUnit>(builder: (context, unit, child) {
      return Expanded(
        child: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
            depth: -3,
            intensity: 0.9,
          ),
          child: TextFormField(decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: bodyText1?.copyWith(fontSize: 16),
                contentPadding:
                    EdgeInsets.only(top: 14.0, left: 18, right: 14, bottom: 18),
                labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
              )),
        ),
      );
    });
  }
}

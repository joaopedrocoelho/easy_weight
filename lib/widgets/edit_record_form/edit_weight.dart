import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:provider/provider.dart';

class EditWeightTextField extends StatefulWidget {
  final String initialValue;
  final void Function(String?)? onSaved;
  final FocusNode hintFocus;

  const EditWeightTextField(
      {Key? key,
      required this.initialValue,
      required this.onSaved,
      required this.hintFocus})
      : super(key: key);

  @override
  _EditWeightTextFieldState createState() => _EditWeightTextFieldState();
}

class _EditWeightTextFieldState extends State<EditWeightTextField> {
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
      return Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
          depth: -3,
          intensity: 0.9,
        ),
        child: TextFormField(
            initialValue: widget.initialValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter weight';
              }
              return null;
            },
            onSaved: widget.onSaved,
            focusNode: widget.hintFocus,
            keyboardType: TextInputType.number,
            cursorColor: theme.defaultTextColor,
            decoration: InputDecoration(
              hintText: unit.usePounds ? "Weight (lb)" : "Weight (kg)",
              hintStyle: bodyText1?.copyWith(fontSize: 16),
              contentPadding:
                  EdgeInsets.only(top: 14.0, left: 18, right: 14, bottom: 18),
              labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),

              /* focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(width: 0.0, color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(width: 0.0, color: Colors.grey)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(width: 0.0, color: Colors.grey)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(width: 0.0, color: Colors.grey)), */
            )),
      );
    });
  }
}

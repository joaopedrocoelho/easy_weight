import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AddWeightTextField extends StatelessWidget {
  final String initialValue;
  final void Function(String?)? onSaved;
  final FocusNode hintFocus;

  const AddWeightTextField(
      {Key? key,
      required this.initialValue,
      required this.onSaved,
      required this.hintFocus})
      : super(key: key);

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
        child: TextFormField(
            initialValue: initialValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter weight';
              }
              return null;
            },
            onSaved: onSaved,
            focusNode: hintFocus,
            keyboardType: TextInputType.number,
            cursorColor: theme.defaultTextColor,
            decoration: InputDecoration(
              hintText: "Weight (kg)",
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
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AddNoteTextField extends StatelessWidget {
  final String initialValue;
  final void Function(String?)? onSaved;

  const AddNoteTextField(
      {Key? key, required this.initialValue, required this.onSaved})
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
          keyboardType: TextInputType.text,
          
          onSaved: onSaved,
          cursorColor: theme.defaultTextColor,
          decoration: InputDecoration(
            hintText: "Add Note",
            hintStyle: bodyText1?.copyWith(fontSize: 16),
            contentPadding: EdgeInsets.only(top:14.0, left:18, right: 14, bottom:18),
            focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.0, color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.0, color: Colors.transparent)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(width: 0, color: Colors.transparent)),
                    disabledBorder: null,
          ),
        ));
  }
}

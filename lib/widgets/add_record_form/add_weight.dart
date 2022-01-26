import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/button_mode.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:provider/provider.dart';

class AddWeightTextField extends StatefulWidget {
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
  _AddWeightTextFieldState createState() => _AddWeightTextFieldState();
}

class _AddWeightTextFieldState extends State<AddWeightTextField> {
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    final bodyText1 = theme.textTheme.bodyText1;

    return Consumer2<WeightUnit, ButtonMode>(
        builder: (context, unit, mode, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
                depth: -3,
                intensity: 0.9,
              ),
              child: TextFormField(
                  style: theme.textTheme.bodyText1,
                  initialValue:
                      mode.addWeight == null ? '' : mode.addWeight.toString(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        _error = true;
                      });

                      return '';
                    } else {
                      setState(() {
                        _error = false;
                      });
                      return null;
                    }
                  },
                  onSaved: widget.onSaved,
                  focusNode: widget.hintFocus,
                  keyboardType: TextInputType.number,
                  cursorColor: theme.defaultTextColor,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 0, height: 0),
                    hintText: unit.usePounds ? "Weight (lb)" : "Weight (kg)",
                    hintStyle: bodyText1?.copyWith(fontSize: 16),
                    contentPadding: EdgeInsets.only(
                        top: 14.0, left: 18, right: 14, bottom: 18),
                    labelStyle:
                        TextStyle(color: Colors.transparent, fontSize: 20.0),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.0, color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.0, color: Colors.transparent)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent)),
                  ))),
          _error
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 20),
                  child: Text(
                    'Please enter weight',
                    style: TextStyle(fontSize: 14, color: Color(0xffE8407A)),
                  ),
                )
              : SizedBox(height: 0)
        ],
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class UnitToggle extends StatefulWidget {
  const UnitToggle({Key? key}) : super(key: key);

  @override
  _UnitToggleState createState() => _UnitToggleState();
}

class _UnitToggleState extends State<UnitToggle> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    int _selectedIndex;

    return NeumorphicToggle(
      children: [
        ToggleElement(
            background: Container(
                                child: Text(
                  'kg',
                  style: theme.textTheme.bodyText1,
                )),
            foreground: Container(
               
                child: Text(
                  'kg',
                  style: theme.textTheme.bodyText1,
                ))),
        ToggleElement(
            background: Container(
                width: 50,
                height: 50,
                child: Text(
                  'lb',
                  style: theme.textTheme.bodyText1,
                )),
            foreground: Container(
                width: 50,
                height: 50,
                child: Text(
                  'lb',
                  style: theme.textTheme.bodyText1,
                )))
      ],
      thumb: Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.all(Radius.circular(12)),
          ),
        ),
        child: Icon(
          Icons.blur_on,
          color: Colors.grey,
        ),
      ),
      onAnimationChangedFinished: (value) {
        if (value == 0) {
        
        }
      },
      onChanged: (value) {
        setState(() {
          _selectedIndex = value;
          print("_firstSelected: $_selectedIndex");
        });
      },
    );
  }
}

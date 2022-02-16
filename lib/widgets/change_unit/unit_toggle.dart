//import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:provider/provider.dart';

class UnitToggle extends StatefulWidget {
  const UnitToggle({Key? key}) : super(key: key);

  @override
  _UnitToggleState createState() => _UnitToggleState();
}

class _UnitToggleState extends State<UnitToggle> {
  late int _selectedIndex;
  @override
  void initState() {
    // TODO: implement initState

    Provider.of<WeightUnit>(context, listen: false).usePounds ? _selectedIndex = 1 : _selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    final bool isUsingDark = NeumorphicTheme.isUsingDark(context);

    return NeumorphicToggle(
      selectedIndex: _selectedIndex,
      displayForegroundOnlyIfSelected: true,
      height: 30,
      width: 80,
      style: NeumorphicToggleStyle(
          backgroundColor: theme.shadowDarkColor,
          depth: isUsingDark ? -4 : -5,
          lightSource: LightSource.topLeft,
          borderRadius: BorderRadius.all(Radius.circular(60))),
      children: [
        ToggleElement(
            background: Container(
                child: Center(
              child: Text(
                'kg',
                style: theme.textTheme.headline5
                    ?.copyWith(fontSize: 15, color: theme.defaultTextColor),
              ),
            )),
            foreground: Neumorphic(
                style: NeumorphicStyle(
                  color: Color(0xff12A3F8),
                  shadowDarkColor: theme.shadowDarkColor,
                  shadowLightColor: theme.shadowLightColor,
                  shadowLightColorEmboss: theme.shadowLightColorEmboss,
                  depth: 5,
                  intensity: 1,
                  surfaceIntensity: 1,
                  boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.all(Radius.circular(30))),
                ),
                child: Center(
                  child: Text(
                    'kg',
                    style: theme.textTheme.headline5
                        ?.copyWith(fontSize: 15, color: theme.baseColor),
                  ),
                ))),
        ToggleElement(
            background: Center(
              child: Text(
                'lb',
                style: theme.textTheme.headline5
                    ?.copyWith(fontSize: 15, color: theme.defaultTextColor),
              ),
            ),
            foreground: Neumorphic(
              style: NeumorphicStyle(
                color: Color(0xff12A3F8),
                boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.all(Radius.circular(30))),
              ),
              child: Center(
                child: Text(
                  'lb',
                  style: theme.textTheme.headline5
                      ?.copyWith(fontSize: 15, color: theme.baseColor),
                ),
              ),
            ))
      ],
      thumb: Neumorphic(
        style: NeumorphicStyle(
          color: Color(0xff12A3F8),
          shadowDarkColor: theme.shadowDarkColor,
          shadowLightColor: theme.shadowLightColor,
          shadowLightColorEmboss: theme.shadowLightColorEmboss,
          depth: 5,
          intensity: 1,
          surfaceIntensity: 1,
          boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.all(Radius.circular(30))),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _selectedIndex = value;
          if (value == 1) {
            Provider.of<WeightUnit>(context, listen: false).setPounds();
          } else {
            Provider.of<WeightUnit>(context, listen: false).setKilograms();
          }
        });
      },
    );
  }
}

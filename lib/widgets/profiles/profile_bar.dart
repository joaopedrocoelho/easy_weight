import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/utils/logger_instace.dart';
import 'package:easy_weight/widgets/buttons/edit_buttons.dart';
import 'package:easy_weight/widgets/neumorphic/neumorphic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class ProfileBar extends StatefulWidget {
  final int id;
  final String? name;
  final String? emoji;
  final Gender? gender;
  final double? height;
  final DateTime? birthday;
  final Color? color;
  final bool isSelected;
  final void Function(dynamic) onSelect;

  ProfileBar(
      {required this.id,
      this.name,
      this.emoji,
      this.gender,
      this.height,
      this.birthday,
      this.color,
      required this.isSelected,
      required this.onSelect,
      Key? key})
      : super(key: key);

  @override
  _ProfileBarState createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
  late String genderString;
  late String birthdayString;
  bool _isOpen = false;
  bool _isSelected = false;

  String getGenderString(Gender? gender) {
    switch (gender) {
      case Gender.male:
        return 'M';
      case Gender.female:
        return "F";
      case Gender.intersex:
        return "I";
      case Gender.non_binary:
        return "N";
      case Gender.transgender:
        return "T";
      case Gender.other:
        return "O";
      case Gender.undefined:
        return "-";
      default:
        return "-";
    }
  }

  @override
  void initState() {
    logger.d(widget.gender, widget.birthday);
    genderString = getGenderString(widget.gender!);
    birthdayString = widget.birthday != null
        ? DateFormat.yMd().format(widget.birthday!)
        : "-";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

    Widget _dropDownArrow() {
      return GestureDetector(
        onTap: () {
          setState(() {
            _isOpen = !_isOpen;
          });
        },
        child: Icon(
          _isOpen ? Icons.expand_less_outlined : Icons.expand_more_outlined,
          size: 36,
          color: theme.defaultTextColor,
        ),
      );
    }

    Widget _profileField(String title, String? value) {
      return Container(
        //color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              value ?? "-",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            )
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left:12.0, right: 12, top: 15),
      child: AnimatedSize(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
            depth: -2,
            intensity: 20,
            surfaceIntensity: 1,
            color: widget.color?.withOpacity(0.4) ?? Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
              bottom: 12,
              left: 8,
              right: 12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  key: Key("profile_bar_row"),
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _dropDownArrow(),
                    Text(
                      widget.emoji ?? '😃',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.name ?? 'No name',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                    Spacer(),
                    NeumorphicCheckbox(
                      style: NeumorphicCheckboxStyle(
                        selectedDepth: -2,
                        selectedIntensity: 0.7,
                        selectedColor: theme.accentColor,
                        boxShape: NeumorphicBoxShape.circle(),
                        
                      
                      ),
                      value: widget.isSelected, 
                      onChanged: widget.onSelect,
                      )
                    /* Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: Colors.transparent,
                        value: true,
                        onChanged: (value) {},
                      ),
                    ), */
                  ],
                ),
                if (_isOpen)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: [
                      _profileField("gender", genderString),
                      _profileField(
                          "height", widget.height?.toStringAsFixed(2)),
                      _profileField("birthday", birthdayString),
                      Container(
                        //color field
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "COLOR",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: widget.color ?? Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: theme.defaultTextColor, width: 2)),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: NeuButton(
                          isVisible: true,
                          child: Icon(
                            Icons.edit,
                            color: theme.defaultTextColor,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: NeuButton(
                          isVisible: true,
                          child: Icon(
                            Icons.delete,
                            color: theme.defaultTextColor,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

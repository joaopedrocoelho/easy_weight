
import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/models/user_settings.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:easy_weight/utils/convert_unit.dart';
import 'package:easy_weight/utils/database.dart';
import 'package:easy_weight/utils/logger_instace.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:easy_weight/widgets/dialog/neu_alert_dialog.dart';
import 'package:easy_weight/widgets/neumorphic/neumorphic_button.dart';
import 'package:easy_weight/widgets/profiles/edit_profile_form.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileBar extends StatefulWidget {
  final int id;
  final int index;
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
      required this.index,
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
  late String heightString;
  bool _isOpen = false;

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

  String getHeightString(double? height) {
    if(height != null) {
      Unit unit = UserSettings.getUnit();
    return unit == Unit.imperial
      ? metersToFt(height).toStringAsFixed(1) + ' ft'
        : height.toStringAsFixed(2) + ' m'; 
    } else {
      return "-";
    }
  }

  @override
  void initState() {
  
    genderString = getGenderString(widget.gender);
    birthdayString = widget.birthday != null
        ? DateFormat.yMd().format(widget.birthday!)
        : "-";
      heightString = getHeightString(widget.height);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProfileBar oldWidget) {
    genderString = getGenderString(widget.gender);
    birthdayString = widget.birthday != null
        ? DateFormat.yMd().format(widget.birthday!)
        : "-";
    heightString = getHeightString(widget.height);
    super.didUpdateWidget(oldWidget);
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
              textAlign: TextAlign.center,
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

    return Consumer2<ProfilesListModel, WeightUnit>(builder: (context, profilesList, unit, child) {
      Future<void> deleteProfile() async {
        logger.i("Deleting profile: ${widget.id}",
            profilesList.profiles[widget.index].toJson());
        await RecordsDatabase.instance.deleteProfile(widget.id);
        if (widget.id == profilesList.selectedProfileID) {
          profilesList.selectProfile(0); //select first profile

        }
        List<Profile> updatedList =
            await RecordsDatabase.instance.getProfiles();
        profilesList.updateList(updatedList);
        setState(() {
          _isOpen = false;
        });
        Navigator.pop(context);
      }


      return Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, top: 15),
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
                      Text(widget.name ?? AppLocalizations.of(context)!.noName,
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
                    ],
                  ),
                  if (_isOpen)
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      children: [
                        _profileField(AppLocalizations.of(context)!.gender, getGenderString(widget.gender)),
                        _profileField(
                            AppLocalizations.of(context)!.height, getHeightString(widget.height) ),
                        _profileField(AppLocalizations.of(context)!.birthday, birthdayString),
                        Container(
                          //color field
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.color.toUpperCase(),
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
                                        color: theme.defaultTextColor,
                                        width: 2)),
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
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: EditProfile(
                                          id:widget.id,
                                          name: widget.name,
                                          emoji: widget.emoji,
                                          color: widget.color,
                                          gender: widget.gender,
                                          height: widget.height,
                                          birthday: widget.birthday,
                                        ));
                                  });
                            },
                            intensity: widget.color != null ? 0.4 : 0.9,
                          ),
                        ),
                        if (Provider.of<ProfilesListModel>(context)
                                .profiles
                                .length >
                            1)
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: NeuButton(
                              isVisible: true,
                              child: Icon(
                                Icons.delete,
                                color: theme.defaultTextColor,
                              ),
                              onPressed: () {
                                showDialog(context: context, 
                                builder: (context) {
                                    return Scaffold(
                                      backgroundColor: Colors.transparent,
                                      body: Center(
                                        child: NeuDialogBox(
                                          message: AppLocalizations.of(context)!.deleteProfileDialog,
                                          onPressed: deleteProfile,
                                        ),
                                      ),
                                    );
                                });
                              },
                              intensity: widget.color != null ? 0.4 : 0.9,
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
    });
  }
}

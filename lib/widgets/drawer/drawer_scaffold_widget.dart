import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/user_settings.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/utils/database.dart';
import 'package:easy_weight/widgets/buttons/menu_button.dart';
import 'package:easy_weight/widgets/change_unit/unit_toggle.dart';
import 'package:easy_weight/widgets/neumorphic/neumorphic_button.dart';
import 'package:easy_weight/widgets/profiles/add_profile_form.dart';
import 'package:easy_weight/widgets/profiles/profile_bar.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class DrawerScaffoldWidget extends StatefulWidget {
  DrawerScaffoldWidget({Key? key}) : super(key: key);

  @override
  _DrawerScaffoldWidgetState createState() => _DrawerScaffoldWidgetState();
}

class _DrawerScaffoldWidgetState extends State<DrawerScaffoldWidget>
    with TickerProviderStateMixin {
  late AnimationController _addProfileFormController;

  void addProfile() {}

  @override
  void initState() {
    // TODO: implement initState
    _addProfileFormController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  Future<List<WeightRecord>> _getRecords(BuildContext context) async {
    Provider.of<RecordsListModel>(context, listen: false).isLoading = true;
    List<WeightRecord> records =
        await RecordsDatabase.instance.getRecords(UserSettings.getProfile()!);
    Provider.of<RecordsListModel>(context, listen: false)
        .updateRecordsList(records);
    Provider.of<RecordsListModel>(context, listen: false).isLoading = false;
    return records;
  }

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

    return Consumer<ProfilesListModel>(builder: (context, profilesList, child) {
    

      return Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Profiles", style: theme.textTheme.headline4),
                    NeumorphicButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Scaffold(
                                  backgroundColor:  Colors.transparent,
                                  body: AddProfile(),
                                );
                              });

                          _addProfileFormController.forward();
                        },
                        style: NeumorphicStyle(
                          color: theme.baseColor,
                          depth: 5,
                          surfaceIntensity: 0.3,
                          intensity: 0.9,
                          shape: NeumorphicShape.convex,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(15)),
                        ),
                        child: Center(
                            child: Icon(
                                Icons.add_circle_outline_rounded,
                                color: theme.defaultTextColor,
                                size: 30)))
                  ],
                ),
              ),
              if (profilesList.profiles.length > 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        color: theme.baseColor,
                        depth: -5,
                        surfaceIntensity: 0.3,
                        intensity: 0.9,
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(15)),
                      ),
                      child: ListView.builder(
                        itemCount: profilesList.profilesCount,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return ProfileBar(
                              id: profilesList.profiles[index].id!,
                              index: index,
                              name: profilesList.profiles[index].name,
                              emoji: profilesList.profiles[index].emoji,
                              gender: profilesList.profiles[index].gender,
                              color: profilesList.profiles[index].color,
                              height: profilesList.profiles[index].height,
                              birthday: profilesList.profiles[index].birthday,
                              isSelected: profilesList.selectedProfileID ==
                                  profilesList.profiles[index].id,
                              onSelect: (_) async {
                                profilesList.selectProfile(
                                    profilesList.profiles[index].id!);
                                await UserSettings.setProfile(
                                    profilesList.profiles[index].id!);
                                _getRecords(context);
                              });
                        },
                      ),
                    ),
                  ),
                ),

                Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                MenuButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UnitToggle(),
                ),
              ],
            ),
          ),
            ],
          ),
        ),
      );
    });
  }
}

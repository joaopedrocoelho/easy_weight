import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/widgets/buttons/menu_button.dart';
import 'package:easy_weight/widgets/neumorphic/neumorphic_button.dart';
import 'package:easy_weight/widgets/profiles/add_profile_form.dart';
import 'package:easy_weight/widgets/profiles/profile_bar.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget  {
  DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> with TickerProviderStateMixin {
  late AnimationController _addProfileFormController;

  void addProfile() {}

  @override
  void initState() {
    // TODO: implement initState
  _addProfileFormController = 
    AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

    return Consumer<ProfilesListModel>(builder: (context, profilesList, child) {
      print("profiles length : ${profilesList.profiles.length}");

      return SafeArea(
        child: Stack(
          children: [
            Drawer(
                backgroundColor: theme.baseColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Profiles", style: theme.textTheme.headline4),
                          NeumorphicButton(
                              onPressed: () {
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
                                  child: Icon(Icons.add_circle_outline_rounded,
                                      color: theme.defaultTextColor, size: 30)))
                        ],
                      ),
                    ),
                    if (profilesList.profiles.length > 0)
                      ListView.builder(
                        itemCount: profilesList.profilesCount,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return ProfileBar(
                              id: profilesList.profiles[index].id,
                              name: profilesList.profiles[index].name);
                        },
                      ),
                    MenuButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),

               

            AddProfile(
              animationController: _addProfileFormController,             
              setVisible: () { _addProfileFormController.forward();}, 
              setInvisible: () { _addProfileFormController.reverse();}, 
              ),
              
              
          ],
        ),
      );
    });
  }
}

import 'package:easy_weight/models/ad_state.dart';
import 'package:easy_weight/models/button_mode.dart';
import 'package:easy_weight/models/goal_model.dart';
import 'package:easy_weight/models/offerings.dart';

import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/user_settings.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/utils/database.dart';
import 'package:easy_weight/widgets/buttons/menu_button.dart';
import 'package:easy_weight/widgets/buy_pro_dialog/buy_pro_dialog.dart';
import 'package:easy_weight/widgets/buy_pro_dialog/error_dialog.dart';
import 'package:easy_weight/widgets/change_unit/unit_toggle.dart';

import 'package:easy_weight/widgets/profiles/add_profile_form.dart';
import 'package:easy_weight/widgets/profiles/profile_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class DrawerScaffoldWidget extends StatefulWidget {
  DrawerScaffoldWidget({Key? key}) : super(key: key);

  @override
  _DrawerScaffoldWidgetState createState() => _DrawerScaffoldWidgetState();
}

class _DrawerScaffoldWidgetState extends State<DrawerScaffoldWidget>
    with TickerProviderStateMixin {
  late BannerAd banner;
  late AnimationController _addProfileFormController;
  Widget? adWidget;

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
            adUnitId: adState.bannerAdUnitId,
            size: AdSize.banner,
            request: AdRequest(),
            listener: adState.bannerAdListener)
          ..load();
        adWidget = Flexible(flex: 1, child: AdWidget(ad: banner));
      });
    });
  }

  @override
  void initState() {
   
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

    return Consumer2<ProfilesListModel, UserOfferings>(builder: (context, profilesList, userOfferings, child) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (adWidget != null && !userOfferings.isPro) adWidget!,
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 12, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.profiles,
                          style: theme.textTheme.headline4),
                      NeumorphicButton(
                          onPressed: () {
                          if(userOfferings.isPro != true && profilesList.profiles.length >= 2) {
                            //show Purchase dialog
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Scaffold(
                                    backgroundColor: Colors.transparent,
                                    body: userOfferings.hasError ? ErrorDialog() : BuyProDialog(),
                                  );
                                });

                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Scaffold(
                                    backgroundColor: Colors.transparent,
                                    body: AddProfile(),
                                  );
                                });

                          }
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
              ),
              if (profilesList.profiles.length > 0)
                Flexible(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                      child: ConstrainedBox(
                        constraints: BoxConstraints.expand(),
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
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
                                  Provider.of<GoalModel>(context, listen: false)
                                      .getGoal(
                                          profilesList.profiles[index].id!);
                                  await UserSettings.setProfile(
                                      profilesList.profiles[index].id!);
                                  _getRecords(context);
                                  if (Provider.of<ButtonMode>(context,
                                          listen: false)
                                      .isEditing)
                                    Provider.of<ButtonMode>(context,
                                            listen: false)
                                        .setAdd();
                                });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, top: 12, bottom: 16),
                    child: Row(
                      children: [
                        MenuButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: UnitToggle(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

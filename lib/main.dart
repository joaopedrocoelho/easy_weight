import 'package:easy_weight/models/db/profiles_table.dart';
import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/models/user_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/goal_model.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:easy_weight/widgets/provide_records.dart';

import 'package:provider/provider.dart';

import 'package:easy_weight/utils/database.dart';
import 'package:easy_weight/models/button_mode.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSettings.init();

  runApp(MyApp());
}

Future<List<ProfileModel>> _getProfiles(BuildContext context) async {
  final profiles = await RecordsDatabase.instance.getProfiles();
  print("profiles db: $profiles");
  Provider.of<ProfilesListModel>(context, listen: false).updateList(profiles);
  return profiles;
}

Future<List<WeightRecord>> _getRecords(BuildContext context) async {
  Provider.of<RecordsListModel>(context, listen: false).isLoading = true;
  List<WeightRecord> records =
      await RecordsDatabase.instance.getRecords(UserSettings.getProfile() ?? 0);
  Provider.of<RecordsListModel>(context, listen: false)
      .updateRecordsList(records);
  Provider.of<RecordsListModel>(context, listen: false).isLoading = false;
  return records;
}

Future<Goal?> _getGoal(BuildContext context) async {
  Goal? goal = await RecordsDatabase.instance.getGoal();
  if (goal != null) {
    Provider.of<GoalModel>(context, listen: false).updateGoalRecord(goal);
    print('_getGoal $goal');
    return goal;
  } else {
    print('_getGoal $goal');
    return null;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Weight',
      //materialTheme: ThemeData(backgroundColor: Color(0xffD5E1EB)),
      //materialDarkTheme: ThemeData(backgroundColor: Color(0xff212733)),
      themeMode: ThemeMode.system,
      theme: NeumorphicThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color(0xff223761),
                fontSize: 14,
                fontWeight: FontWeight.normal),

            headline3: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color(0xff223761),
                fontSize: 25,
                fontWeight: FontWeight.w800),
            headline4: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color(0xff223761),
                fontSize: 35,
                fontWeight: FontWeight.w800), //goal button

            headline5: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color(0xff223761),
                fontSize: 20,
                fontWeight: FontWeight.w800),
            button: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color(0xff223761),
                fontSize: 16,
                fontWeight: FontWeight.w800),
            subtitle1: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color(0xff5d626e),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5),
            caption: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color(0xff5d626e),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5),
            subtitle2: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color(0xff223761),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5),
          ),
          baseColor: Color(0xffD5E1EB),
          defaultTextColor: Color(0xff223761),
          shadowDarkColor: Color(0xFFA7BCCF),
          shadowLightColorEmboss: Color(0xffEDF7FF),
          lightSource: LightSource.topLeft,
          intensity: 1,
          depth: 10,
          borderColor: Colors.transparent),
      darkTheme: NeumorphicThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color.fromRGBO(255, 255, 255, 0.85),
                fontSize: 14,
                fontWeight: FontWeight.normal),

            headline3: TextStyle(
                fontFamily: 'Noto Sans',
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w800),
            headline4: TextStyle(
                fontFamily: 'Noto Sans',
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w800), //goal button

            headline5: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color.fromRGBO(255, 255, 255, 0.85),
                fontSize: 20,
                fontWeight: FontWeight.w800),
            button: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color(0xff223761),
                fontSize: 16,
                fontWeight: FontWeight.w800),
            subtitle1: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color(0xff5d626e),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5),
            caption: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color(0xffB6C5D5),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5),
            subtitle2: TextStyle(
                fontFamily: 'Noto Sans',
                color: Color.fromRGBO(255, 255, 255, 0.85),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5),
          ),
          baseColor: Color(0xff212733),
          defaultTextColor: Color(0xffB6C5D5),
          shadowDarkColor: Color(0xFF161A22),
          shadowLightColor: Color(0xff2D3648),
          shadowLightColorEmboss: Color(0xff2F384E),
          lightSource: LightSource.topLeft,
          intensity: 1,
          depth: 10,
          borderColor: Colors.transparent),
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => RecordsListModel()),
            ChangeNotifierProvider(create: (context) => GoalModel()),
            ChangeNotifierProvider(create: (context) => ProfilesListModel()),
            
            ChangeNotifierProvider(create: (context) => ButtonMode()),
            ChangeNotifierProvider(create: (context) => WeightUnit()),
            FutureProvider<List<ProfileModel>?>(
            create: (context) {
               return _getProfiles(context);
              },
              initialData: [],
              catchError: (_, error) => [
                ProfileModel(
                  id: -1,
                  name: 'hasError: $error',
                )
              ],
            ),
            FutureProvider<Goal?>(
                create: (context) {
                  return _getGoal(context);
                },
                initialData: null,
                catchError: (_, error) {
                  print(error);
                  return null;
                }),
            FutureProvider<List<WeightRecord>?>(
                create: (context) {
                  return _getRecords(context);
                },
                initialData: [],
                catchError: (_, error) => [
                      WeightRecord(
                          date: DateTime.now(),
                          weight: 00.0,
                          note: 'hasError: $error',
                          profileId: -1)
                    ]),
          ],
          builder: (context, child) {
            return ProvideRecords();
          }),
    );
  }
}

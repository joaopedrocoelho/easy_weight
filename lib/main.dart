import 'package:easy_weight/models/ad_state.dart';
import 'package:easy_weight/models/db/profiles_table.dart';
import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/models/user_settings.dart';
import 'package:easy_weight/utils/logger_instace.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/goal_model.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:easy_weight/widgets/provide_records.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:provider/provider.dart';

import 'package:easy_weight/utils/database.dart';
import 'package:easy_weight/models/button_mode.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  await UserSettings.init();

  runApp(Provider.value(value: adState, builder: (context, child) => MyApp()));
}

Future<List<Profile>> _getProfiles(BuildContext context) async {
  final profiles = await RecordsDatabase.instance.getProfiles();
  print("profiles db: $profiles");
  Provider.of<ProfilesListModel>(context, listen: false).updateList(profiles);
  Provider.of<ProfilesListModel>(context, listen: false)
      .selectProfile(UserSettings.getProfile() ?? 0);
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
  Goal? goal =
      await RecordsDatabase.instance.getGoal(UserSettings.getProfile() ?? 0);
  if (goal != null) {
    Provider.of<GoalModel>(context, listen: false).updateGoalRecord(goal);

    logger.i('_getGoal $goal');
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecordsListModel()),
        ChangeNotifierProvider(create: (context) => GoalModel()),
        ChangeNotifierProvider(create: (context) => ProfilesListModel()),
        ChangeNotifierProvider(create: (context) => ButtonMode()),
        ChangeNotifierProvider(
            create: (context) => WeightUnit(UserSettings.getUnit())),
        FutureProvider<List<Profile>?>(
          create: (context) {
            return _getProfiles(context);
          },
          initialData: [],
          catchError: (_, error) => [
            Profile(
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
        return NeumorphicApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('af', ''),
            Locale('sq', ''),
            Locale('am', ''),
            Locale('ar', ''),
            Locale('hy', ''),
            Locale('az', ''),
            Locale('eu', ''),
            Locale('be', ''),
            Locale('bn', ''),
            Locale('bs', ''),
            Locale('bg', ''),
            Locale('ca', ''),
            Locale('ceb', ''),
            Locale('ny', ''),
            Locale('zh-cn', ''),
            Locale('zh-tw', ''),
            Locale('co', ''),
            Locale('hr', ''),
            Locale('cs', ''),
            Locale('da', ''),
            Locale('nl', ''),
            Locale('eo', ''),
            Locale('et', ''),
            Locale('tl', ''),
            Locale('fi', ''),
            Locale('fr', ''),
            Locale('fy', ''),
            Locale('gl', ''),
            Locale('ka', ''),
            Locale('de', ''),
            Locale('el', ''),
            Locale('gu', ''),
            Locale('ht', ''),
            Locale('ha', ''),
            Locale('haw', ''),
            Locale('iw', ''),
            Locale('he', ''),
            Locale('hi', ''),
            Locale('hmn', ''),
            Locale('hu', ''),
            Locale('is', ''),
            Locale('ig', ''),
            Locale('id', ''),
            Locale('ga', ''),
            Locale('it', ''),
            Locale('jw', ''),
            Locale('kn', ''),
            Locale('kk', ''),
            Locale('km', ''),
            Locale('ko', ''),
            Locale('ku', ''),
            Locale('ky', ''),
            Locale('lo', ''),
            Locale('la', ''),
            Locale('lv', ''),
            Locale('lt', ''),
            Locale('lb', ''),
            Locale('mk', ''),
            Locale('mg', ''),
            Locale('ms', ''),
            Locale('ml', ''),
            Locale('mt', ''),
            Locale('mi', ''),
            Locale('mr', ''),
            Locale('mn', ''),
            Locale('my', ''),
            Locale('ne', ''),
            Locale('no', ''),
            Locale('or', ''),
            Locale('ps', ''),
            Locale('fa', ''),
            Locale('pl', ''),
            Locale('pa', ''),
            Locale('ro', ''),
            Locale('ru', ''),
            Locale('sm', ''),
            Locale('gd', ''),
            Locale('sr', ''),
            Locale('st', ''),
            Locale('sn', ''),
            Locale('sd', ''),
            Locale('si', ''),
            Locale('sk', ''),
            Locale('sl', ''),
            Locale('so', ''),
            Locale('su', ''),
            Locale('sw', ''),
            Locale('sv', ''),
            Locale('tg', ''),
            Locale('ta', ''),
            Locale('te', ''),
            Locale('th', ''),
            Locale('tr', ''),
            Locale('uk', ''),
            Locale('ur', ''),
            Locale('ug', ''),
            Locale('uz', ''),
            Locale('vi', ''),
            Locale('cy', ''),
            Locale('xh', ''),
            Locale('yi', ''),
            Locale('yo', ''),
            Locale('zu', ''),
            Locale('en', ''),
            Locale('pt', ''),
            Locale('ja', ''),
            Locale('es', ''),
            Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
            Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
          ],
          debugShowCheckedModeBanner: false,
          title: 'Easy Weight',
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
                    color: Color(0xffB6C5D5),
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
          home: ProvideRecords(),
        );
      },
    );
  }
}

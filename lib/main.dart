import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:new_app/models/records_model.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/widgets/provide_records.dart';

import 'package:provider/provider.dart';

import 'package:new_app/utils/database.dart';
import 'package:new_app/models/button_mode.dart';

void main() {
  runApp(MyApp());
}

Future<List<WeightRecord>> _getRecords(BuildContext context) async {
  List<WeightRecord> records = await RecordsDatabase.instance.getRecords();
  Provider.of<RecordsListModel>(context, listen: false)
      .updateRecordsList(records);
  return records;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  NeumorphicApp(
      title: 'Easy Weight',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        textTheme: TextTheme(
          
          bodyText1: TextStyle(fontFamily: 'Noto Sans', color: 
        Color(0xff223761), fontSize: 14,
                          fontWeight: FontWeight.normal),
                        
        headline3: TextStyle(fontFamily: 'Noto Sans', color: 
        Color(0xff223761), fontSize: 35, fontWeight: FontWeight.w800),
        headline5:TextStyle(fontFamily: 'Noto Sans', color: 
        Color(0xff223761), fontSize: 20, fontWeight: FontWeight.w800),
        button: TextStyle(fontFamily: 'Noto Sans', color: 
        Color(0xff223761), fontSize: 16, fontWeight: FontWeight.w800),
        subtitle1: TextStyle(fontFamily: 'Noto Sans', color: Color(0xff5d626e),
        fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        caption: TextStyle(fontFamily: 'Noto Sans', color: Color(0xff5d626e),
        fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        subtitle2: TextStyle(fontFamily: 'Noto Sans', color: Color(0xff223761),
        fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        

       
        ),
        baseColor: Color(0xffD5E1EB),
        defaultTextColor: Color(0xff223761),
        shadowDarkColor: Color(0xFFA7BCCF),
        shadowLightColorEmboss: Color(0xffEDF7FF),
        lightSource: LightSource.topLeft,
        intensity: 1,
        depth: 10,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => RecordsListModel()),
            ChangeNotifierProvider(create: (context) => ButtonMode()),
            FutureProvider<List<WeightRecord>?>(
                create: (context) {
                  return _getRecords(context);
                },
                initialData: [],
                catchError: (_, error) => [
                      WeightRecord(
                          date: DateTime.now(),
                          weight: 00.0,
                          note: 'hasError: $error')
                    ])
          ],
          builder: (context, child) {
            return ProvideRecords();
          }),
    );
  }
}

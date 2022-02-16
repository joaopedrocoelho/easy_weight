import 'package:easy_weight/models/profile_model.dart';
import 'package:flutter/material.dart';

import 'package:easy_weight/models/goal_model.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/screens/home.dart';
import 'package:provider/provider.dart';

class ProvideRecords extends StatelessWidget {
  const ProvideRecords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<List<WeightRecord>?, Goal?, List<Profile>?>(
        builder: (context, list, goal, profilesList, child) {
      if (list != null) {
        if (list.isNotEmpty && list[0].note.contains('hasError:')) {
          return returnError(list);
        } else {
          return Consumer2<RecordsListModel, GoalModel>(
            builder: (context, recordsModel, goalModel, child) {
              return Home(list: recordsModel.records);
            },
          );
        }
      } else {
        return Text('List is null');
      }
    });
  }

  Widget returnError(List<WeightRecord> list) {
    print('error  ${list[0].note}');
    return Center(
        child: Container(
            width: 200,
            height: 200,
            child: Text('something wrong: ${list[0].note}')));
  }
}

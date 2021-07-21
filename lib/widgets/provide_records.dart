import 'package:flutter/material.dart';
import 'package:new_app/models/button_mode.dart';
import 'package:new_app/models/records_model.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/screens/home.dart';
import 'package:provider/provider.dart';

class ProvideRecords extends StatelessWidget {
  const ProvideRecords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<List<WeightRecord>?>(builder: (context, list, child) {
      if (list != null) {
        if (list.isNotEmpty && list[0].note.contains('hasError:')) {
          return returnError(list);
        } else {
          return Consumer<RecordsListModel>(
            builder: (context, recordsModel, child) {
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

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:new_app/models/records_model.dart';
import 'package:provider/provider.dart';

class EmptyGraphContainer extends StatelessWidget {
  const EmptyGraphContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    return Consumer<RecordsListModel>(builder: (context, records, child) {



      return Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: records.isLoading ? 
          SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              color: Color(0xff12A3F8),
              backgroundColor: theme.shadowDarkColor,
              strokeWidth: 10,
            ),
          )
          : Text(
            'Add your current weight to start',
            style: theme.textTheme.headline3,
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }
}

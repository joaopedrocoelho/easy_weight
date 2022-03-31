import 'package:easy_weight/utils/logger_instace.dart';

import 'package:easy_weight/models/button_mode.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/utils/database.dart';
import 'package:easy_weight/widgets/neumorphic/neumorphic_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class EditButtons extends StatefulWidget {
  final VoidCallback onPressed;

  EditButtons({required this.onPressed});

  @override
  _EditButtonsState createState() => _EditButtonsState();
}

class _EditButtonsState extends State<EditButtons> {
  /* bool _editVisibility = false; */

  Future deleteRecordFromDB(WeightRecord deletedRecord) async {
    await RecordsDatabase.instance.deleteRecord(deletedRecord);
  }

  /* void _setEditVisible() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _editVisibility = true;
      });
    });
  }

  void _setEditInVisible() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _editVisibility = false;
      });
    });
  } */

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    return Consumer<ButtonMode>(builder: (context, buttonMode, child) {
      //buttonMode.isEditing ? _setEditVisible() : _setEditInVisible();

      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //delete button
               AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: buttonMode.isEditing ? 1.0 : 0.0,
                child: Container(
                  height: 60,
                  child: NeuButton(
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: theme.defaultTextColor,
                      size: 30,
                    ),
                    onPressed: () {
                       
                      logger.i('deleting record from profile ${buttonMode.profileId}');
                      WeightRecord deletedRecord = WeightRecord(
                          date: buttonMode.date,
                          weight: buttonMode.weight,
                          note: buttonMode.note,
                          profileId: buttonMode.profileId);
              
                      Provider.of<RecordsListModel>(context, listen: false)
                          .deleteRecord(deletedRecord);
              
                      deleteRecordFromDB(deletedRecord);
                      buttonMode.setAdd();
                    },
                    isVisible: buttonMode.isEditing,
                  ),
                ),
              ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              height: 60,
              child: NeuButton(
                  onPressed: widget.onPressed,
                  child: buttonMode.isEditing
                      ? Icon(Icons.mode_edit_outline_rounded,
                          color: theme.defaultTextColor, size: 30)
                      : Icon(Icons.add_circle_outline_rounded,
                          color: theme.defaultTextColor, size: 30),
                  isVisible: true),
            ),
          ],
        ),
      );
    });
  }
}

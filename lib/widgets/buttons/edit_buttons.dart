import 'package:flutter/material.dart';
import 'package:new_app/models/button_mode.dart';
import 'package:new_app/models/records_model.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/utils/database.dart';
import 'package:new_app/widgets/neumorphic/neumorphic_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class EditButtons extends StatefulWidget {
  final VoidCallback addOnPressed;

  EditButtons({required this.addOnPressed});

  @override
  _EditButtonsState createState() => _EditButtonsState();
}

class _EditButtonsState extends State<EditButtons> {

   bool _editVisibility = false;

  Future deleteRecordFromDB(WeightRecord deletedRecord) async {
    await RecordsDatabase.instance.delete(deletedRecord);
  }

  void _setEditVisible() {
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    return Consumer<ButtonMode>(builder: (context, buttonMode, child) {
        buttonMode.isEditing ?  _setEditVisible() :
          _setEditInVisible();



      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //delete button
              if(_editVisibility) 
              NeuButton(
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: theme.defaultTextColor,
                  size: 30,
                ),
                addOnPressed: () {
                  WeightRecord deletedRecord = WeightRecord(
                      date: buttonMode.date,
                      weight: buttonMode.weight,
                      note: buttonMode.note);

                  Provider.of<RecordsListModel>(context, listen: false)
                      .deleteRecord(deletedRecord);

                  deleteRecordFromDB(deletedRecord);
                  buttonMode.setAdd();
                },
                isVisible: buttonMode.isEditing,
              ),
              SizedBox(
                width: 20.0,
              ),
               NeuButton(
                    addOnPressed: widget.addOnPressed,
                    child: _editVisibility ? Icon(Icons.mode_edit_outline_rounded,
                        color: theme.defaultTextColor, size: 30) : Icon(Icons.add_circle_outline_rounded,
                        color: theme.defaultTextColor, size: 30),
                    isVisible: true),
              
            ],
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:new_app/models/button_mode.dart';
import 'package:new_app/models/records_model.dart';

import 'package:new_app/widgets/add_record_form/add_note.dart';
import 'package:new_app/widgets/add_record_form/add_weight.dart';
import 'package:new_app/widgets/add_record_form/neu_close_button.dart';
import 'package:new_app/widgets/add_record_form/neu_date_picker.dart';
import 'package:new_app/widgets/buttons/cancel_button.dart';
import 'package:new_app/widgets/buttons/save_button.dart';

import 'package:intl/intl.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/utils/database.dart';
import 'package:new_app/widgets/edit_record_form/edit_weight.dart';
import 'package:new_app/widgets/edit_record_form/neu_edit_date.dart';
import 'package:provider/provider.dart';

import 'package:new_app/widgets/add_record_form/neu_form_container.dart';

class EditRecord extends StatefulWidget {
  final AnimationController animationController;
  final VoidCallback setVisible;
  final VoidCallback setInvisible;

  final List<WeightRecord> records;

  final double weight;
  final DateTime date;
  final String note;

  EditRecord({
    required this.animationController,
    required this.setVisible,
    required this.setInvisible,
    required this.records,
    required this.weight,
    required this.date,
    required this.note,
  });

  @override
  _EditRecordState createState() => _EditRecordState();
}

class _EditRecordState extends State<EditRecord>
    with SingleTickerProviderStateMixin {
  late FocusNode hintFocus;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  //form fields state
  double _weight = 0.0;
  String _initialWeight = '';
  String _initialNote = '';

  String _note = '';

  Future updateRecord() async {
    WeightRecord editedRecord =
        new WeightRecord(date: widget.date, weight: _weight, note: _note);
    final record = await RecordsDatabase.instance.updateRecord(editedRecord);

    widget.setInvisible();
  }

  @override
  void initState() {
    super.initState();

    hintFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    hintFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonMode>(builder: (context, buttonMode, child) {
      String _initialWeight = buttonMode.weight.toString();
      FocusScopeNode currentFocus = FocusScope.of(context);

      print('currentFocus: ${currentFocus.focusedChild}');

      return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
              parent: widget.animationController, curve: Curves.ease)),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: NeuFormContainer(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Record',
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.start,
                        ),
                        NeuCloseButton(onPressed: widget.setInvisible)
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    EditWeightTextField(
                        hintFocus: hintFocus,
                        initialValue: _weight.toString(),
                        onSaved: (value) {
                          setState(() {
                            _weight = double.parse(value!);
                          });
                        }),
                    SizedBox(
                      height: 30.0,
                    ),
                    EditDateForm(date: buttonMode.date),
                    SizedBox(
                      height: 30.0,
                    ),
                    AddNoteTextField(
                        initialValue: _note,
                        onSaved: (value) {
                          setState(() {
                            _note = value!;
                          });
                        }),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: CancelButton(onPressed: () {
                          setState(() {
                            _weight = 0.0;
                            _note = '';
                          });
                          widget.setInvisible();
                        })),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(child: SaveButton(onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.

                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            print(
                                '_weight : $_weight widget.date: ${widget.date} note:$_note');
                            WeightRecord editedRecord = new WeightRecord(
                                date: widget.date,
                                weight: _weight,
                                note: _note);

                            Provider.of<RecordsListModel>(context,
                                    listen: false)
                                .editRecord(editedRecord);

                            updateRecord();
                            setState(() {
                              _weight = 0.0;
                              _note = '';
                            });
                            buttonMode.isEditing = false;
                            buttonMode.selectedIndex = null;
                            
 
                           
                              currentFocus.focusedChild?.unfocus();
                         
                          }
                        }))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }
}

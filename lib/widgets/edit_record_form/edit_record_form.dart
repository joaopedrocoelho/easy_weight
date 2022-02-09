import 'package:easy_weight/utils/convert_unit.dart';
import 'package:flutter/material.dart';
import 'package:easy_weight/models/button_mode.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_unit.dart';

import 'package:easy_weight/widgets/add_record_form/add_note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:easy_weight/widgets/add_record_form/neu_close_button.dart';

import 'package:easy_weight/widgets/buttons/cancel_button.dart';
import 'package:easy_weight/widgets/buttons/save_button.dart';

import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/utils/database.dart';
import 'package:easy_weight/widgets/edit_record_form/edit_weight.dart';
import 'package:easy_weight/widgets/edit_record_form/neu_edit_date.dart';
import 'package:provider/provider.dart';

import 'package:easy_weight/widgets/add_record_form/neu_form_container.dart';

class EditRecord extends StatefulWidget {


  final List<WeightRecord> records;

  final double weight;
  final DateTime date;
  final String note;

  EditRecord({

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
  late AnimationController _animationController;

  late FocusNode hintFocus;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  //form fields state
  double _weight = 0.0;


  String _note = '';

  Future updateRecord() async {
    WeightRecord editedRecord = new WeightRecord(
        date: widget.date, weight: _weight, note: _note, profileId: 0);
    final record = await RecordsDatabase.instance.updateRecord(editedRecord);

    Navigator.pop(context);
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animationController.forward();
    super.initState();

    hintFocus = FocusNode();
  }

  @override
  void dispose() {
      _animationController.dispose();

    hintFocus.dispose();
    super.dispose();
  
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ButtonMode, WeightUnit>(
        builder: (context, buttonMode, unit, child) {
 
      FocusScopeNode currentFocus = FocusScope.of(context);

      return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
              parent: _animationController, curve: Curves.ease)),
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
                         AppLocalizations.of(context)!.editRecord,
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.start,
                        ),
                        NeuCloseButton(onPressed: () {
                          _animationController.reverse();
                          Navigator.pop(context);
                        })
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
                            unit.usePounds
                                ? _weight = lbsToKg(double.parse(value!))
                                : _weight = double.parse(value!);
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
                          _animationController.reverse();
                          Navigator.pop(context);
                        })),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(child: SaveButton(onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          print(
                              "edit record: ${_formKey.currentState!.validate()}");
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            print(
                                '_weight : $_weight widget.date: ${widget.date} note:$_note');
                            WeightRecord editedRecord = new WeightRecord(
                                date: widget.date,
                                weight: _weight,
                                note: _note,
                                profileId: 0);

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
                            _animationController.reverse();
                            Navigator.pop(context);
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

import 'package:easy_weight/models/user_settings.dart';
import 'package:easy_weight/utils/convert_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:intl/intl.dart';
import 'package:easy_weight/models/button_mode.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_unit.dart';

import 'package:easy_weight/widgets/add_record_form/add_note.dart';
import 'package:easy_weight/widgets/add_record_form/add_weight.dart';
import 'package:easy_weight/widgets/add_record_form/neu_close_button.dart';
import 'package:easy_weight/widgets/add_record_form/neu_date_picker.dart';
import 'package:easy_weight/widgets/add_record_form/neu_form_container.dart';
import 'package:easy_weight/widgets/buttons/cancel_button.dart';
import 'package:easy_weight/widgets/buttons/save_button.dart';

import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/utils/database.dart';
import 'package:provider/provider.dart';

class AddRecord extends StatefulWidget {
  final AnimationController animationController;
  final VoidCallback setVisible;
  final VoidCallback setInvisible;

  final List<WeightRecord> records; //not sure if neeeded

  AddRecord({
    required this.animationController,
    required this.records,
    required this.setVisible,
    required this.setInvisible,
  });

  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord>
    with SingleTickerProviderStateMixin {
  late FocusNode hintFocus;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  //form fields state
  double _weight = 0;
  DateTime _date = DateTime.now();
  String _note = '';

//datepicker selected date

  Future addRecord(int profileId) async {
    WeightRecord newRecord = new WeightRecord(
        date: _date, weight: _weight, note: _note, profileId: profileId);
    final record = await RecordsDatabase.instance.addRecord(newRecord);

    // List<WeightRecord> recordsClone = graph.records;

    //print('record: $record');

    widget.setInvisible();

    return record;
  }

  @override
  void initState() {
    super.initState();

    hintFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    widget.animationController.dispose();
    hintFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final Animation<Offset> _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: widget.animationController, curve: Curves.ease));

    FocusScopeNode currentFocus = FocusScope.of(context);

    return Consumer3<WeightUnit, RecordsListModel, ButtonMode>(
        builder: (context, unit, records, mode, child) {
      void _setDate(DateTime newDate) {
        setState(() {
          _date = newDate;
          records.newFormattedDate(newDate);
        });
      }

      return SlideTransition(
        position: _offsetAnimation,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 410,
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
                          'Add a record',
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.start,
                        ),
                        NeuCloseButton(onPressed: widget.setInvisible),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    AddWeightTextField(
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
                    NeuDatePicker(
                      callback: _setDate,
                      currentDate:
                          context.watch<RecordsListModel>().lastAvailableDate,
                      records: widget.records,
                      usedDates: context.watch<RecordsListModel>().usedDates,
                      selectedDate: records.formattedCurrentDate,
                    ),
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
                        Expanded(
                            child:
                                CancelButton(onPressed: widget.setInvisible)),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(child: SaveButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              WeightRecord newRecord = new WeightRecord(
                                  date: _date,
                                  weight: _weight,
                                  note: _note,
                                  profileId: 0);

                              List<WeightRecord> recordsClone =
                                  Provider.of<RecordsListModel>(context,
                                          listen: false)
                                      .records;
                              recordsClone.add(newRecord);
                              Provider.of<RecordsListModel>(context,
                                      listen: false)
                                  .updateRecordsList(recordsClone);

                              addRecord(UserSettings.getProfile() ?? 0);
                              setState(() {
                                _note = '';
                                _weight = 0.0;
                              });

                              mode.clearData();

                              currentFocus.focusedChild?.unfocus();
                            }
                          },
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:new_app/models/records_model.dart';
import 'package:new_app/widgets/add_record_form/add_note.dart';
import 'package:new_app/widgets/add_record_form/add_weight.dart';
import 'package:new_app/widgets/add_record_form/neu_close_button.dart';
import 'package:new_app/widgets/add_record_form/neu_date_picker.dart';
import 'package:new_app/widgets/add_record_form/neu_form_container.dart';
import 'package:new_app/widgets/buttons/cancel_button.dart';
import 'package:new_app/widgets/buttons/save_button.dart';

import 'package:new_app/models/weight_record.dart';
import 'package:new_app/utils/database.dart';
import 'package:provider/provider.dart';

class AddRecord extends StatefulWidget {
  final AnimationController animationController;
  final bool visible;
  final VoidCallback setVisible;
  final VoidCallback setInvisible;
  final Function() setRefresh; //not sure if neeeded

  AddRecord(
      {required this.animationController,
      required this.visible,
      required this.setVisible,
      required this.setInvisible,
      required this.setRefresh});

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

  void _setDate(DateTime newDate) {
    setState(() {
      _date = newDate;
    });
  }

  Future addRecord() async {
    WeightRecord newRecord =
        new WeightRecord(date: _date, weight: _weight, note: _note);
    final record = await RecordsDatabase.instance.addRecord(newRecord);

    // List<WeightRecord> recordsClone = graph.records;

    print('record: $record');

    widget.setInvisible();
    widget.setRefresh();
    return record;
  }

  Future updateRecord() async {
    WeightRecord editedRecord =
        new WeightRecord(date: _date, weight: _weight, note: _note);
    final record = await RecordsDatabase.instance.updateRecord(editedRecord);

    print('record: $record');

    widget.setInvisible();
    widget.setRefresh();
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
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
          parent: widget.animationController, curve: Curves.ease)),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Visibility(
          visible: widget.visible,
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
                          _weight = double.parse(value!);
                        });
                      }),
                  SizedBox(
                    height: 30.0,
                  ),
                  NeuDatePicker(
                      callback: _setDate, currentDate: DateTime.now()),
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
                          child: CancelButton(onPressed: widget.setInvisible)),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(child: SaveButton(
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            WeightRecord newRecord = new WeightRecord(
                                date: _date, weight: _weight, note: _note);

                            List<WeightRecord> recordsClone =
                                Provider.of<RecordsListModel>(context,
                                        listen: false)
                                    .records;
                            recordsClone.add(newRecord);
                            Provider.of<RecordsListModel>(context,
                                    listen: false)
                                .updateRecordsList(recordsClone);

                            addRecord();
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
  }
}

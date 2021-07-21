import 'package:flutter/material.dart';
import 'package:new_app/models/button_mode.dart';
import 'package:new_app/models/records_model.dart';
import 'package:new_app/utils/render_graph.dart';
import 'package:new_app/widgets/date_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/utils/database.dart';
import 'package:provider/provider.dart';

class EditRecord extends StatefulWidget {
  final AnimationController animationController;
  final bool visible;
  final VoidCallback setVisible;
  final VoidCallback setInvisible;
  final Function() setRefresh;
  final double weight;
  final DateTime date;
  final String note;

  EditRecord({
    required this.animationController,
    required this.visible,
    required this.setVisible,
    required this.setInvisible,
    required this.setRefresh,
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
  DateTime _date = DateTime.now();
  String _formattedDate = '';
  String _note = '';

  void _setDate(DateTime newDate) {
    setState(() {
      _date = newDate;
      _formattedDate = DateFormat('MM/dd').format(newDate);
    });
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
    _date = widget.date;

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
          child: Container(
            height: 420,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
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
                        style: TextStyle(
                          backgroundColor: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: const ShapeDecoration(
                          color: Colors.grey,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                          ),
                          color: Colors.black,
                          iconSize: 15.0,
                          padding: EdgeInsets.all(0.0),
                          onPressed: widget.setInvisible,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                      initialValue: widget.weight.toString(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter weight';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _weight = double.parse(value!);
                        });
                      },
                      focusNode: hintFocus,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        fillColor: Colors.grey,
                        filled: true,
                        hintText: "Weight (kg)",
                        hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 20.0),
                        contentPadding: EdgeInsets.all(16.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(width: 0.0, color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(width: 0.0, color: Colors.grey)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(width: 0.0, color: Colors.grey)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(width: 0.0, color: Colors.grey)),
                      )),
                  SizedBox(
                    height: 30.0,
                  ),
                  DatePicker(callback: _setDate, currentDate: widget.date),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: widget.note,
                      onSaved: (value) {
                        setState(() {
                          _note = value!;
                        });
                      },
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        fillColor: Colors.grey,
                        filled: true,
                        hintText: "Add Note",
                        hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
                        contentPadding: EdgeInsets.all(16.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(width: 0.0, color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(width: 0.0, color: Colors.grey)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(width: 0.0, color: Colors.grey)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(width: 0.0, color: Colors.grey)),
                      )),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.setInvisible,
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'CANCEL',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          color: Colors.red, width: 1.0)))),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                WeightRecord editedRecord = new WeightRecord(
                                    date: _date, weight: _weight, note: _note);
        
                                Provider.of<RecordsListModel>(context,
                                        listen: false)
                                    .editRecord(editedRecord);
        
                                updateRecord();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text('SAVE'),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color: Colors.blue, width: 1.0))))),
                      )
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

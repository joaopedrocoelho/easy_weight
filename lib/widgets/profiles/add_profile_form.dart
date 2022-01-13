import 'package:easy_weight/widgets/profiles/emoji_picker.dart';
import 'package:easy_weight/widgets/profiles/neu_birthday_picker.dart';
import 'package:easy_weight/widgets/profiles/text_field.dart';
import 'package:easy_weight/widgets/profiles/text_field_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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

class AddProfile extends StatefulWidget {
  final AnimationController animationController;
  final VoidCallback setVisible;
  final VoidCallback setInvisible;

  AddProfile({
    required this.animationController,
    required this.setVisible,
    required this.setInvisible,
  });

  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile>
    with SingleTickerProviderStateMixin {
  late FocusNode hintFocus;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  //form fields state
  double _weight = 0;
  DateTime _date = DateTime.now();
  String _note = '';

//datepicker selected date

  Future addProfile() async {}

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
    final theme = NeumorphicTheme.currentTheme(context);
    final bodyText1 = theme.textTheme.bodyText1;

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
          child: NeuFormContainer(
            height: 452,
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
                        'Add a profile',
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.start,
                      ),
                      NeuCloseButton(onPressed: widget.setInvisible),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  NeuTextField(
                      initialValue: "",
                      errorText: "Please enter a name",
                      hintText: "Name",
                      onSaved: (value) {},
                      hintFocus: hintFocus),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      NeuEmojiPicker(
                          initialValue: "",
                          errorText: "",
                          hintText: "Emoji",
                          onSaved: (value) {},
                          hintFocus: hintFocus),
                      SizedBox(
                        width: 30,
                      ),
                      NeuTextFieldMedium(
                          initialValue: "",
                          errorText: "",
                          hintText: "Gender",
                          onSaved: (value) {},
                          hintFocus: hintFocus)
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  NeuBirthdayPicker(),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      NeuTextFieldMedium(
                          initialValue: "",
                          errorText: "",
                          hintText: "Height",
                          onSaved: (value) {},
                          hintFocus: hintFocus),
                      SizedBox(
                        width: 30,
                      ),
                      Neumorphic(
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(25)),
                          depth: -3,
                          intensity: 0.9,
                        ),
                        padding: EdgeInsets.only(top: 14.0, left: 18, right: 14, bottom: 14),
                        child: Row(
                          children: [
                            Text("Color", style: bodyText1?.copyWith(fontSize: 16),),
                            SizedBox(width: 10,),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                             
                              height: 25,
                              width: 25,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
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

                            addProfile();
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
      );
    });
  }
}

import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/widgets/profiles/emoji_picker.dart';
import 'package:easy_weight/widgets/profiles/gender_picker.dart';
import 'package:easy_weight/widgets/profiles/neu_birthday_picker.dart';
import 'package:easy_weight/widgets/profiles/number_field_medium.dart';
import 'package:easy_weight/widgets/profiles/text_field.dart';
import 'package:easy_weight/widgets/profiles/text_field_small.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_unit.dart';

import 'package:easy_weight/widgets/add_record_form/neu_close_button.dart';

import 'package:easy_weight/widgets/add_record_form/neu_form_container.dart';
import 'package:easy_weight/widgets/buttons/cancel_button.dart';
import 'package:easy_weight/widgets/buttons/save_button.dart';

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
  bool _hideEmojiPicker = true;
  bool _hideGenderPicker = true;
  late AnimationController _emojiPickerController;

  //form fields state
   String _selectedEmoji = "😃";
   String _name = "";
   String _gender = "";

//datepicker selected date

  Future addProfile() async {}

  @override
  void initState() {
    super.initState();
    _emojiPickerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _emojiPickerController.forward();
    hintFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    widget.animationController.dispose();
    hintFocus.dispose();
  }

  /* @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _hideEmojiPicker == false ? 
    _emojiPickerController.forward() : _emojiPickerController.reverse();
    super.didChangeDependencies();
  } */

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    final bodyText1 = theme.textTheme.bodyText1;


    late final Animation<Offset> _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: widget.animationController, curve: Curves.ease));

    late final Animation<Offset> _emojiPickerAnimation = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _emojiPickerController, curve: Curves.ease));

    FocusScopeNode currentFocus = FocusScope.of(context);

    return Consumer<ProfilesListModel>(builder: (context, profiles, child) {
      return Stack(children: [
        SlideTransition(
          position: _offsetAnimation,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: NeuFormContainer(
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
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
                          initialValue: profiles.selectedProfile?.name ?? _name,
                          errorText: "Please enter a name",
                          hintText: "Name",
                          onSaved: (value) {
                            setState(() {
                              _name = value ?? "";
                           
                            });
                            print("name: $_name");
                          },
                          onTap: () {
                            setState(() {
                              _hideEmojiPicker = true;
                            
                            });
                          },
                          hintFocus: hintFocus),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _hideEmojiPicker = !_hideEmojiPicker;
                                  });
                                },
                                child: NeuEmojiPicker(
                                    emoji: profiles.selectedProfile?.emoji ??
                                        _selectedEmoji) ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _hideGenderPicker = !_hideGenderPicker;
                                });
                              },
                              child: NeuGenderPicker(gender: _gender)),
                          )
                        ]),
                      SizedBox(
                        height: 30.0,
                      ),
                      NeuBirthdayPicker(birthday: DateTime.now(), onSaved: () {}),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          NeuNumberFieldMedium(
                              initialValue: "",
                              errorText: "",
                              hintText: "Height",
                              onSaved: (value) {},
                              hintFocus: hintFocus),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(25)),
                                depth: -3,
                                intensity: 0.9,
                              ),
                              padding: EdgeInsets.only(
                                  top: 14.0, left: 18, right: 14, bottom: 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Color",
                                    style: bodyText1?.copyWith(fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      height: 25,
                                      width: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40,
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
                              currentFocus.focusedChild?.unfocus();
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
        ),
        SlideTransition(
          position: _emojiPickerAnimation,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.33,
              child: Offstage(
                offstage: _hideEmojiPicker,
                child: EmojiPicker(
                  onBackspacePressed: () {
                    /* _emojiPickerController.reverse().whenComplete(() => 
                       setState(() {
                      _hideEmojiPicker = true;
                    })
                            ); */
                     setState(() {
                      _hideEmojiPicker = true;
                    });
                   
                  },
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _selectedEmoji = emoji.toJson()['emoji'];
                    });
                    print("emoji: ${emoji.toJson()['emoji']}");
                    print("_selectedEmoji: $_selectedEmoji");
                  },
                ),
              ),
            ),
          ),
        ),

        Align(
          child: Offstage(
            offstage: _hideGenderPicker,
            child: Neumorphic(child: 
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                children: [
                 _buildGender("Male", Gender.male),
                 _buildGender("Female", Gender.female),
                 _buildGender("Non binary", Gender.non_binary),
                 _buildGender("Transgender", Gender.transgender),
                 _buildGender("Intersex", Gender.intersex),
                 _buildGender("Other", Gender.other),
                  //NeumorphicRadio(child: Text("male"),)
                ],
              ),
            ),),
          ),
        )
      ]);
    });
  }

  Widget _buildGender(String caption, Gender value) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: NeumorphicRadio(
        groupValue: Gender,
        value: value,
        padding: EdgeInsets.all(10),
        onChanged: (value) {
          setState(() {
            _gender = caption[0].toUpperCase();
            _hideGenderPicker = true;
          });
          print("value: $value");
        } ,
        style: NeumorphicRadioStyle(
          selectedDepth: -3,
        ),
        child: Text(caption),),
    );
  }
}
/* male,
  female,
  non_binary,
  transgender,
  intersex,
  other,
  undefined, */

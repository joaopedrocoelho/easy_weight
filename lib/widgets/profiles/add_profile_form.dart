import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/models/user_settings.dart';
import 'package:easy_weight/utils/database.dart';
import 'package:easy_weight/widgets/profiles/emoji_picker.dart';
import 'package:easy_weight/widgets/profiles/gender_picker.dart';
import 'package:easy_weight/widgets/profiles/neu_birthday_picker.dart';
import 'package:easy_weight/widgets/profiles/height_field_medium.dart';
import 'package:easy_weight/widgets/profiles/text_field.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';


import 'package:easy_weight/widgets/add_record_form/neu_close_button.dart';

import 'package:easy_weight/widgets/add_record_form/neu_form_container.dart';
import 'package:easy_weight/widgets/buttons/cancel_button.dart';
import 'package:easy_weight/widgets/buttons/save_button.dart';

import 'package:provider/provider.dart';

import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);


const List<Color> colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
  Colors.white
];

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
  int _portraitCrossAxisCount = 4;
  int _landscapeCrossAxisCount = 5;
  double _borderRadius = 30;
  double _blurRadius = 5;
  double _iconSize = 14;
  late FocusNode hintFocus;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _hideEmojiPicker = true;
  bool _hideGenderPicker = true;
  bool _hideColorPicker = true;
  late AnimationController _emojiPickerController;

  //save profile function
  Future<int> addProfile(Profile newProfile) async {
      final  int profile = await RecordsDatabase.instance.addProfile(newProfile);
      if (profile != -1) {
        Profile newProfileWithId = Profile(
          id: profile,
          name: newProfile.name,
          emoji: newProfile.emoji,
          gender: newProfile.gender,
          color: newProfile.color,
          birthday: newProfile.birthday,
          height: newProfile.height,
          );
        Provider.of<ProfilesListModel>(context, listen: false).addProfile(newProfileWithId);
      }

    return profile;
  } 

  double convertHeight(double height) {
    double convertedHeight =
    UserSettings.getUnit() == 'metric' ?
     height : height * 0.3048;


   return convertedHeight;
  }
 
  //form fields state
  String _selectedEmoji = "😃";
  String _name = "";
  Gender _gender = Gender.undefined;
  DateTime _birthday = DateTime.now();
  double _height = 0.0;
  Color _selectedColor = Colors.transparent;


  //color picker builder
  Widget pickerLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    final theme = NeumorphicTheme.currentTheme(context);

    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 400,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait
            ? _portraitCrossAxisCount
            : _landscapeCrossAxisCount,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  //color item picker

  Widget pickerItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.8),
              offset: const Offset(1, 2),
              blurRadius: _blurRadius)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

//datepicker selected date



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
                      Row(children: [
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _hideEmojiPicker = !_hideEmojiPicker;
                                });
                              },
                              child: NeuEmojiPicker(
                                  emoji: profiles.selectedProfile?.emoji ??
                                      _selectedEmoji)),
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
                      NeuBirthdayPicker(
                          birthday: DateTime.now(), onSaved: () {}),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          NeuHeightField(
                              initialValue: "",
                              errorText: "",
                              hintText: "",
                              onSaved: (value) {
                                double height =  value != null ? double.parse(value) : 0.0;
                                setState(() {
                                  _height = height;
                                });
                                print("height: $_height");
                              
                              },
                              hintFocus: hintFocus),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _hideColorPicker = false;
                                });
                              },
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
                                            color: _selectedColor,
                                            border: Border.all(
                                              color: theme.defaultTextColor,width: 4
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  ],
                                ),
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
                              double convertedHeight = convertHeight(_height);
                               Profile newProfile = Profile(
                                    name: _name,
                                    emoji: _selectedEmoji,
                                    height: convertedHeight,
                                    gender: _gender,
                                    birthday: _birthday,
                                    color: _selectedColor,
                                );

                                addProfile(newProfile).then((value) => {
                                  if (value != -1) {


                                  } else{
                                    //error handling
                                  }
                                }
                                );

                              

                              logger.d({
                                  "name": _name,
                                  "emoji": _selectedEmoji,
                                  "height": _height,
                                  "gender": _gender,
                                  "color": _selectedColor,
                                  "birthday": _birthday,
                              }
                              );
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
            child: Neumorphic(
              child: Padding(
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
              ),
            ),
          ),
        ),
        Align(
          child: Offstage(
            offstage: _hideColorPicker,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Neumorphic(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                          height: 460,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0, left: 12),
                          child:
                              Text("Pick a color", style: theme.textTheme.headline3),
                        ),
                        NeuCloseButton(onPressed: () {
                          print("close");
                          setState(() {
                            _hideColorPicker = true;
                          });
                        })
                      ],
                    ),
                        BlockPicker(
                            pickerColor: _selectedColor,
                            availableColors: colors,
                            layoutBuilder: pickerLayoutBuilder,
                            onColorChanged: (Color color) {
                              setState(() {
                                _selectedColor = color;
                              });
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
            _gender = value as Gender;
            _hideGenderPicker = true;
          });
          print("value: $value");
        },
        style: NeumorphicRadioStyle(
          selectedDepth: -3,
        ),
        child: Text(caption),
      ),
    );
  }
}

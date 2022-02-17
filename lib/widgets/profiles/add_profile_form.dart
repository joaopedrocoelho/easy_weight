import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/models/user_settings.dart';
import 'package:easy_weight/utils/convert_unit.dart';
import 'package:easy_weight/utils/database.dart';
import 'package:easy_weight/utils/logger_instace.dart';
import 'package:easy_weight/widgets/profiles/input_fields/color_field.dart';

import 'package:easy_weight/widgets/profiles/input_fields/emoji_input_field.dart';
import 'package:easy_weight/widgets/profiles/input_fields/gender_input_field.dart';
import 'package:easy_weight/widgets/profiles/input_fields/neu_birthday_picker.dart';
import 'package:easy_weight/widgets/profiles/input_fields/text_field.dart';

import 'package:easy_weight/widgets/profiles/input_fields/height_field_medium.dart';
import 'package:easy_weight/widgets/profiles/pickers/color_picker.dart';
import 'package:easy_weight/widgets/profiles/pickers/emoji_picker.dart';
import 'package:easy_weight/widgets/profiles/pickers/gender_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:easy_weight/widgets/add_record_form/neu_close_button.dart';

import 'package:easy_weight/widgets/add_record_form/neu_form_container.dart';
import 'package:easy_weight/widgets/buttons/cancel_button.dart';
import 'package:easy_weight/widgets/buttons/save_button.dart';

import 'package:provider/provider.dart';

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
  AddProfile({
    Key? key,
  }) : super(key: key);

  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> with TickerProviderStateMixin {
  int _portraitCrossAxisCount = 4;
  int _landscapeCrossAxisCount = 5;
  double _borderRadius = 30;
  double _blurRadius = 5;
  double _iconSize = 14;
  late FocusNode hintFocus;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  
  late AnimationController _emojiPickerController;
  late AnimationController _slideAnimationController;

  //save profile function
  Future<int> addProfile(Profile newProfile) async {
    final int profile = await RecordsDatabase.instance.addProfile(newProfile);
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
      Provider.of<ProfilesListModel>(context, listen: false)
          .addProfile(newProfileWithId);
    }

    return profile;
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
    logger.i(Unit.metric.toString());
    _emojiPickerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimationController.forward();
    _emojiPickerController.forward();
    hintFocus = FocusNode();
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _emojiPickerController.dispose();
    hintFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
   
    late final Animation<Offset> _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideAnimationController, curve: Curves.ease));

   

    FocusScopeNode currentFocus = FocusScope.of(context);

    return Consumer<ProfilesListModel>(builder: (context, profiles, child) {
      return SlideTransition(
        position: _offsetAnimation,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: NeuFormContainer(
            height: 470,
            child: Container(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.addProfile,
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.start,
                          ),
                          NeuCloseButton(onPressed: () {
                            _slideAnimationController.reverse();
                            Navigator.pop(context);
                          }),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      NeuTextField(
                          initialValue: _name,
                          errorText:  AppLocalizations.of(context)!.nameError,
                          hintText:  AppLocalizations.of(context)!.nameHint,
                          onSaved: (value) {
                            setState(() {
                              _name = value ?? "";
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
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return NeuEmojiPicker(
                                          onEmojiSelected: (category, emoji) {
                                        setState(() {
                                          _selectedEmoji =
                                              emoji.toJson()['emoji'];
                                        });
                                       
                                       logger.i(
                                            "_selectedEmoji: $_selectedEmoji");
                                      });
                                    });
                              },
                              child: EmojiInputField(emoji: _selectedEmoji)),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return NeuGenderPicker(
                                          initialValue: _gender,
                                          onChanged: (value) {
                                            setState(() {
                                              _gender = value as Gender;
                                            });
                                            logger.d("value: $value");
                                          });
                                    });
                              },
                              child: GenderInputField(gender: _gender)),
                        )
                      ]),
                      SizedBox(
                        height: 30.0,
                      ),
                      NeuBirthdayPicker(
                          birthday: _birthday,
                          onSaved: (date) {
                            setState(() {
                              _birthday = date;
                            });
                          }),
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
                                double height = value != null && value != ''
                                    ? double.parse(value)
                                    : 0.0;
                                setState(() {
                                  UserSettings.getUnit() ==  Unit.metric
                                      ? _height = height
                                      : _height = ftToMeters(height);
                                  logger.d("Height: $_height");
                                });
                              },
                              hintFocus: hintFocus),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return NeuColorPicker(
                                          onColorChanged: (Color color) {
                                            setState(() {
                                              _selectedColor = color;
                                            });
                                          },
                                          selectedColor: _selectedColor);
                                    });
                              },
                              child: ColorInputField(color: _selectedColor),
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
                          Expanded(child: CancelButton(onPressed: () {
                            _slideAnimationController.reverse();
                            Navigator.pop(context);
                          })),
                          SizedBox(
                            width: 20.0,
                          ),
                          Expanded(child: SaveButton(
                            onPressed: () async {
                              currentFocus.focusedChild?.unfocus();
                             
                              Profile newProfile = Profile(
                                name: _name,
                                emoji: _selectedEmoji,
                                height: _height,
                                gender: _gender,
                                birthday: _birthday,
                                color: _selectedColor,
                              );

                              addProfile(newProfile).then((value) => {
                                    if (value != -1)
                                      {
                                        _slideAnimationController.reverse(),
                                        Navigator.pop(context),
                                      }
                                    else
                                      {
                                        //error handling
                                      }
                                  });

                              logger.d({
                                "name": _name,
                                "emoji": _selectedEmoji,
                                "height": _height,
                                "gender": _gender,
                                "color": _selectedColor,
                                "birthday": _birthday,
                              });
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
      );
    });
  }
}

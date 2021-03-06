import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/widgets/add_record_form/neu_close_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';


class NeuGenderPicker extends StatefulWidget {
  final void Function(Object?) onChanged;
  final Gender initialValue;
  NeuGenderPicker(
      {required this.onChanged, required this.initialValue, Key? key})
      : super(key: key);

  @override
  _NeuGenderPickerState createState() => _NeuGenderPickerState();
}

class _NeuGenderPickerState extends State<NeuGenderPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Gender _selectedValue;

  @override
  void initState() {
    _selectedValue = widget.initialValue;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ScaleTransition(
        scale: _animation,
        child: Align(
          child: Neumorphic(
            style: NeumorphicStyle(intensity: 0.4),
            child: Container(
              
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top:15.0, right: 15.0),
                      child: NeuCloseButton(onPressed: () {
                        _controller.reverse();
                        Navigator.pop(context);
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      children: [
                        _buildGender(AppLocalizations.of(context)!.male, Gender.male),
                        _buildGender(AppLocalizations.of(context)!.female, Gender.female),
                        _buildGender(AppLocalizations.of(context)!.nonBinary, Gender.non_binary),
                        _buildGender(AppLocalizations.of(context)!.transGender, Gender.transgender),
                        _buildGender(AppLocalizations.of(context)!.interSex, Gender.intersex),
                        _buildGender(AppLocalizations.of(context)!.other, Gender.other),
                        //NeumorphicRadio(child: Text("male"),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGender(String caption, Gender value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: NeumorphicRadio(
        groupValue: _selectedValue,
        value: value,
        padding: EdgeInsets.all(10),
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _selectedValue = newValue as Gender;
            });
          }
          widget.onChanged(value);
          _controller.reverse();
          Navigator.pop(context);
        },
        style: NeumorphicRadioStyle(
          selectedDepth: -3,
        ),
        child: Text(caption),
      ),
    );
  }
}

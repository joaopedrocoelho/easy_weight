import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

typedef void SetDate(DateTime date);

class NeuBirthdayPicker extends StatefulWidget {
  final DateTime? birthday;
  final SetDate onSaved;

  NeuBirthdayPicker({this.birthday, required this.onSaved});

  @override
  _NeuBirthdayPickerState createState() => _NeuBirthdayPickerState();
}

class _NeuBirthdayPickerState extends State<NeuBirthdayPicker> {
  late String _dateFormatted;

  Future<DateTime?> _selectDate(BuildContext context) async {
    dynamic _datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (_datePicker != null) {
      setState(() {
        _dateFormatted = DateFormat.yMd().format(_datePicker);
      });
      widget.onSaved(_datePicker);
      return _datePicker;
    }
  }

  @override
  void initState() {
    if (widget.birthday != null) {
      _dateFormatted = DateFormat.yMd().format(widget.birthday!);
    } else {
      _dateFormatted = DateFormat.yMd().format(DateTime.now());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    final bodyText1 = theme.textTheme.bodyText1;

    return Consumer<ProfilesListModel>(
      builder: (context, profiles, child) {
        return NeumorphicButton(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
              depth: -3,
              intensity: 0.9,
            ),
            padding:
                EdgeInsets.only(top: 14.0, left: 18, right: 14, bottom: 18),
            onPressed: () {
              _selectDate(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _dateFormatted,
                  style: bodyText1?.copyWith(fontSize: 16),
                ),
                Icon(
                  Icons.calendar_today,
                  color: theme.defaultTextColor,
                ),
              ],
            ));
      },
    );
  }
}

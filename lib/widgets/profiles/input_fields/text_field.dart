import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeuTextField extends StatefulWidget {
  final String initialValue;
  final String errorText;
  final String hintText;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final FocusNode hintFocus;

  const NeuTextField(
      {Key? key,
      required this.initialValue,
      required this.errorText,
      required this.hintText,
      required this.onSaved,
      this.onTap,
      required this.hintFocus})
      : super(key: key);

  @override
  _NeuTextFieldState createState() => _NeuTextFieldState();
}

class _NeuTextFieldState extends State<NeuTextField> {
  //TextEditingController _textController = TextEditingController();

  @override
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final theme = NeumorphicTheme.currentTheme(context);
    final bodyText1 = theme.textTheme.bodyText1;
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
        depth: -3,
        intensity: 0.9,
      ),
      child: TextFormField(
          initialValue: widget.initialValue,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.errorText;
            }
            return null;
          },
          onTap: widget.onTap,
          
          onChanged: widget.onSaved,
          focusNode: widget.hintFocus,
          keyboardType: TextInputType.name,
          cursorColor: theme.defaultTextColor,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: bodyText1?.copyWith(fontSize: 16),
            contentPadding:
                EdgeInsets.only(top: 14.0, left: 18, right: 14, bottom: 18),
            labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
          )),
    );
  }
}

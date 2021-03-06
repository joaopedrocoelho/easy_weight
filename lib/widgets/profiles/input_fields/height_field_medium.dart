  import 'package:easy_weight/models/user_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
  import 'package:flutter_neumorphic/flutter_neumorphic.dart';
  import 'package:easy_weight/models/weight_unit.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
  import 'package:provider/provider.dart';

  class NeuHeightField extends StatefulWidget {
    final String initialValue;
    final String errorText;
    final String hintText;
    final void Function(String?)? onSaved;
    final FocusNode hintFocus;

    const NeuHeightField(
        {Key? key,
        required this.initialValue,
        required this.errorText,
        required this.hintText,
        required this.onSaved,
        required this.hintFocus})
        : super(key: key);

    @override
    _NeuHeightFieldState createState() => _NeuHeightFieldState();
  }

  class _NeuHeightFieldState extends State<NeuHeightField> {




    @override
    Widget build(BuildContext context) {
      final theme = NeumorphicTheme.currentTheme(context);
      final bodyText1 = theme.textTheme.bodyText1;

      return Consumer<WeightUnit>(builder: (context, unit, child) {
        return Expanded(
          child: Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
              depth: -3,
              intensity: 0.9,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:18.0,bottom: 14, top:10),
                    child: Text(
                      toBeginningOfSentenceCase(AppLocalizations.of(context)!.height)!, style: bodyText1?.copyWith(fontSize: 16),),
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: widget.onSaved,
                    keyboardType: TextInputType.number,
                    style: bodyText1?.copyWith(fontSize: 16, ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: bodyText1?.copyWith(fontSize: 16),
                        suffixText: unit.usePounds ? "ft" : "cm" ,
                        suffixStyle: bodyText1?.copyWith(fontSize: 16),
                        contentPadding:
                            EdgeInsets.only(top: 14.0, right: 8, bottom: 18,left: 0),
                        labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                ),
                SizedBox(
                 width: 18, 
                )
           
              ],
            ),
          ),
        );
      });
    }
  }

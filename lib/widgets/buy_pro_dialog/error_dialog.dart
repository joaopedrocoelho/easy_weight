import 'package:easy_weight/models/offerings.dart';
import 'package:easy_weight/utils/logger_instace.dart';
import 'package:easy_weight/widgets/add_record_form/neu_close_button.dart';
import 'package:easy_weight/widgets/add_record_form/neu_form_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class ErrorDialog extends StatefulWidget {
  ErrorDialog({Key? key}) : super(key: key);

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideAnimationController;
  String? errorMessage;
  int? errorCode;

  @override
  void initState() {
    super.initState();
    errorMessage = Provider.of<UserOfferings>(context, listen: false).errorMsg;
    _slideAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

   
    final buttonTheme = theme.textTheme.button;

    late final Animation<Offset> _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideAnimationController, curve: Curves.ease));

    return SlideTransition(
      position: _offsetAnimation,
      child: Align(
          alignment: Alignment.bottomCenter,
          child: NeuFormContainer(
            height: 400,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: NeuCloseButton(onPressed: () {
                        _slideAnimationController.reverse();
                        Navigator.pop(context);
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage ?? 'error',
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                                     
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

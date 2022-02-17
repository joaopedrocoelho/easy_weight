import 'package:easy_weight/models/offerings.dart';
import 'package:easy_weight/widgets/add_record_form/neu_form_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class BuyProDialog extends StatefulWidget {
  BuyProDialog({Key? key}) : super(key: key);

  @override
  State<BuyProDialog> createState() => _BuyProDialogState();
}

class _BuyProDialogState extends State<BuyProDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideAnimationController;

  @override
  void initState() {
    super.initState();

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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        AppLocalizations.of(context)!.proOfferingDesc,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                        Provider.of<UserOfferings>(context, listen: false)
                            .availableOfferings
                            .lifetime!
                            .product
                            .priceString,
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: NeumorphicButton(
                        onPressed: () {
                          Provider.of<UserOfferings>(context, listen: false).purchasePro();
                        },
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            intensity: 1,
                            surfaceIntensity: 0.5,
                            depth: 2,
                            color: Color(0xff12A3F8),
                            shadowLightColorEmboss: Color(0xff12A3F8),
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(50)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Center(
                                child: Text(
                                    AppLocalizations.of(context)!
                                        .buy
                                        .toUpperCase(),
                                    style: buttonTheme?.copyWith(
                                        color: Color(0xffFFFFFF)))),
                          )),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

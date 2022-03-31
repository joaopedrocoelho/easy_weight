import 'package:easy_weight/models/offerings.dart';
import 'package:easy_weight/utils/logger_instace.dart';
import 'package:easy_weight/widgets/add_record_form/neu_close_button.dart';
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
  String? errorMessage;
  int? errorCode;

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

    void handlePurchase() {
      Future<bool> purchase =
          Provider.of<UserOfferings>(context, listen: false).purchasePro();
      purchase.then((value) {
        if (value) {
          _slideAnimationController.reverse();
          Navigator.pop(context);
        } else {
          setState(() {
            errorCode =
                Provider.of<UserOfferings>(context, listen: false).errorNumber;
            errorCode == 2
                ? errorMessage = AppLocalizations.of(context)!.purchaseError2
                : errorMessage = AppLocalizations.of(context)!.purchaseError20;
          });
        }
      });
    }

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
                        errorMessage ??
                            AppLocalizations.of(context)!.proOfferingDesc,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    errorMessage != null
                        ? Neumorphic(
                            padding: EdgeInsets.all(5.0),
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                boxShape: NeumorphicBoxShape.circle(),
                                intensity: 1,
                                depth: 2,
                                surfaceIntensity: 0.7,
                                color: Colors.yellow[300]),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.warning,
                                  size: 30, color: Colors.black),
                            ))
                        : Text(
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
                            Provider.of<UserOfferings>(context, listen: false)
                                .getPurchases()
                                .then((value) {
                              if (!value) {
                                handlePurchase();
                              } else {
                                _slideAnimationController.reverse();
                                Navigator.pop(context);
                              }
                            });
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

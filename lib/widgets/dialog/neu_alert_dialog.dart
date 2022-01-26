import 'package:easy_weight/widgets/buttons/cancel_button.dart';
import 'package:easy_weight/widgets/buttons/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeuDialogBox extends StatelessWidget {
  final String message;
  final void Function() onPressed;

  const NeuDialogBox({
    required this.message,
    required this.onPressed,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
          depth: 5,
          intensity: 0.4,
        ),
        child: 
      Padding(
        padding: const EdgeInsets.only(top:0,left: 20,right: 20,bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          
          Expanded(
            child: Container(
             
              child: Center(
                child: Text(message,
                style: theme.textTheme.headline3,
                textAlign: TextAlign.center,),
              ),
            ),
          ),
          
          Row(
            children: [
              Expanded(child: CancelButton(onPressed: () {
                Navigator.pop(context);
              },)),
              
              SizedBox(width: 20,),
              Expanded(child: SaveButton(onPressed: onPressed))
            ],
          )
        ],),
      )
      ),
    );
  }
}
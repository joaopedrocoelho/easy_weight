import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeuButton extends StatelessWidget {
  final VoidCallback addOnPressed;
  final Widget? child;

  const NeuButton({ Key? key , required this.addOnPressed, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  NeumorphicButton(
                onPressed: addOnPressed,
                style: NeumorphicStyle(
                  color:Color(0xffE5F1FB),
                  shadowDarkColor: Color(0xffA7BCCF),
                  shadowDarkColorEmboss: Color(0xffA7BCCF),
                  shadowLightColor:Color(0xffFAFDFF),
                depth: 5,
                surfaceIntensity: 0.3,
                intensity: 0.8
                ,
                
                shape:NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),),
                child:
                   Center(
                      child: child)

      
    );
  }
}
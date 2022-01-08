import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ProfileBar extends StatefulWidget {
  ProfileBar({Key? key}) : super(key: key);

  @override
  _ProfileBarState createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child:/*  Container(
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red[300],
          ) */
          
          Neumorphic(

            style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
              depth: -2,
              intensity: 20,
              surfaceIntensity: 1,
              color: Color.fromRGBO(255, 107, 107, 0.5),
            ),
            
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(children: [
              Text("😀", style: TextStyle(fontSize: 24),),
              SizedBox(width: 20,),
              Text("Carlos Alberto", style: TextStyle(fontSize: 24,
              fontWeight: FontWeight.bold)),
              
            ],
        ),
          ),
      ),
    );
  }
}
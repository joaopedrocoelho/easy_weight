import 'package:easy_weight/widgets/buttons/menu_button.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(backgroundColor: Colors.white,
    child: Stack(children: [
      Positioned(
        bottom: 0,
        top: 0,
        child: 
           MenuButton(onPressed: () {
          Navigator.pop(context);
      },
        ))
    ],));
  }
}
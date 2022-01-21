import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  CustomCheckbox({Key? key}) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        
      ),
    );
  }
}
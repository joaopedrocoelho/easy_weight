import 'package:easy_weight/widgets/neumorphic/neumorphic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MenuButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MenuButton({Key? key, required this.onPressed}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: NeuButton(
                    child: Icon(
                      Icons.menu_rounded,
                      color: theme.defaultTextColor,
                      size: 30,
                    ),
                    onPressed: onPressed,
                    isVisible: true,
                    ),
    );
  }
}
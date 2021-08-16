import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class EmptyGraphContainer extends StatelessWidget {
  const EmptyGraphContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);


    return Container(
      height: MediaQuery.of(context).size.height /2,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          'Add your current weight to start',
          style: theme.textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
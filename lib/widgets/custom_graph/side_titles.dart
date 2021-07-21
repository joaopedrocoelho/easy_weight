import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:new_app/utils/render_graph.dart';
import 'package:provider/provider.dart';
import 'package:new_app/utils/indexed_iterables.dart';

class SideTitles extends StatefulWidget {
  final List<int> sideTitleWeights;
  final double yHeight;
  final double maxDisplayedWeight;

  SideTitles(
      {required this.sideTitleWeights,
      required this.yHeight,
      required this.maxDisplayedWeight});

  @override
  _SideTitlesState createState() => _SideTitlesState();
}

Size _textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

Size whatsTheSize = _textSize(
    "48",
    TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
    ));

class _SideTitlesState extends State<SideTitles> {
  late List<Widget> titles;

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    

    //print('whatstheSize: $whatsTheSize');
    //render left side guide weights
    List<Widget> renderSideTitleWeights() {
      List<Widget> titles = widget.sideTitleWeights.mapIndexed((weight, index) {
        return Positioned(
          bottom: ((widget.yHeight / 5) * (index + 1)) + 5,
          child: Text(weight.toString(),
              style: TextStyle(
                color: theme.shadowDarkColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              )),
        );
      }).toList();

      return titles;
    }

    titles = renderSideTitleWeights();

    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: titles,
      ),
    );
  }
}

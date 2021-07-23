import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:new_app/utils/render_graph.dart';

import 'package:new_app/utils/indexed_iterables.dart';

class SideTitles extends StatelessWidget {
  final List<int> sideTitleWeights;
  final double graphHeight;
  final double maxDisplayedWeight;
  final double minDisplayedWeight;
  final double paddingTop;
  final double bottomTitlesHeight;

  SideTitles(
      {required this.sideTitleWeights,
      required this.graphHeight,
      required this.maxDisplayedWeight,
      required this.minDisplayedWeight,
      required this.paddingTop,
      required this.bottomTitlesHeight});

  
  late List<Widget> titles;

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  } 

  


  
    //render left side guide weights
    List<Widget> renderSideTitleWeights() {
      List<Widget> titles = sideTitleWeights.mapIndexed((weight, index) {
        Size whatsTheSize = _textSize(weight.toString(), theme.textTheme.caption!);
        print('whatstheSize: ${whatsTheSize}');
        print(
            'sidetitlePos ${yPos(weight.toDouble(), graphHeight, maxDisplayedWeight, minDisplayedWeight) - graphHeight}');
        return Positioned(
          bottom:  (yPos(weight.toDouble(), graphHeight, maxDisplayedWeight,
                  minDisplayedWeight) 
               - (whatsTheSize.height * 0.5)) + bottomTitlesHeight  // this makes the title centered ,
              ,
          child: Text(
            weight.toString(),
            style: theme.textTheme.caption,
          ),
        );
      }).toList();

      return titles;
    }

    titles = renderSideTitleWeights();

    return Container(
     /*  color: Colors.amberAccent, */
      child: Stack(
        alignment: Alignment.center,
        children: titles,
      ),
    );
  }
}

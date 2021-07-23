import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:new_app/models/weight_record.dart';

import 'package:new_app/utils/format_weight.dart';
import 'package:new_app/utils/render_graph.dart';

import 'package:new_app/widgets/custom_graph/bottom_titles_row.dart';
import 'package:new_app/widgets/custom_graph/gradient_fill.dart';
import 'package:new_app/widgets/custom_graph/horizontal_lines.dart';
import 'package:new_app/widgets/custom_graph/lines.dart';
import 'package:new_app/widgets/custom_graph/side_titles.dart';
import 'package:new_app/widgets/custom_graph/spots.dart';

class GraphContainer extends StatefulWidget {
  final List<WeightRecord> records;
  final BuildContext context;

  GraphContainer({Key? key, required this.records, required this.context})
      : super(key: key);

  @override
  _GraphContainerState createState() => _GraphContainerState();
}

class _GraphContainerState extends State<GraphContainer> {
  int? _selectedIndex;
  void onGraphSpotTap(int index) {
    setState(() {
      _selectedIndex == index ? _selectedIndex = null : _selectedIndex = index;
    });
  }

  //late List<HorizontalLine> horizontalGuidelines;

//stateless
  int paddingTop = 20;
  int paddingBottom = 40;
  int paddingLeft = 8;

//unknown

  late int fator;

  late ScrollController _graphController;

  @override
  void initState() {
    super.initState();
    _graphController = ScrollController();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_graphController.hasClients) {
        _graphController.jumpTo(_graphController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double minWeight = findMinWeight(widget.records);
    double maxWeight = findMaxWeight(widget.records);
    double range = maxWeight - minWeight;
    int minWeightIndex = getMinWeightIndex(widget.records);
    int maxWeightIndex = getMaxWeightIndex(widget.records);
    double maxDisplayedWeight = setMaxDisplayedWeight(range, maxWeight);
    double minDisplayedWeight =
        setMinDisplayedWeight(minWeight, maxDisplayedWeight);

    double paddingTop = 0;

    double graphHeight = MediaQuery.of(widget.context).size.height /2;

    double graphWidth = //50 is the space between dates
        widget.records.length * 50 > MediaQuery.of(widget.context).size.width
            ? (widget.records.length * 50)
            : MediaQuery.of(widget.context).size.width;

    //https://chezvoila.com/blog/yaxis/
    double lowerThirdScale = (minWeight - minDisplayedWeight) /
        (maxDisplayedWeight - minDisplayedWeight);

    double bottomTitlesHeight = 30;

    List<int> sideTitleWeights = renderSideTitleWeights(minDisplayedWeight, 
    maxDisplayedWeight);

    
   

    List<GraphSpot> spots = renderSpots(
        widget.records,
        graphHeight ,
        bottomTitlesHeight,
        maxDisplayedWeight,
        minDisplayedWeight,
        paddingLeft,
        _selectedIndex,
        onGraphSpotTap);

    List<DrawLines> graphLines = renderLines(graphHeight,
        MediaQuery.of(widget.context).size.width, spots);

    List<DrawHorizontalLines> horizontalGuidelines = renderHorizontalLines(
        graphWidth,
        graphHeight,
        paddingTop,
        maxDisplayedWeight,
        minDisplayedWeight,
        sideTitleWeights);

    List<GFCoordinates> gradientFillBelowGraphCoordinates =
        renderGradientFill(spots);

    List<Widget> graphWidgetsList = [
    
      /* ...horizontalGuidelines, */
      PaintFill(
          fillCoordinates: gradientFillBelowGraphCoordinates,
          graphHeight: graphHeight),
      ...graphLines,
      ...spots,
    ];

    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      //bottom titles widget

      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: graphHeight+ bottomTitlesHeight,
              width: MediaQuery.of(context).size.width / 10,
              child: SideTitles(
                sideTitleWeights: sideTitleWeights,
                graphHeight: graphHeight,
                paddingTop: paddingTop,
                bottomTitlesHeight: bottomTitlesHeight,
                maxDisplayedWeight: maxDisplayedWeight,
                minDisplayedWeight: minDisplayedWeight,
              )),
          //graph widget
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: graphHeight + bottomTitlesHeight,
            child: SingleChildScrollView(
              controller: _graphController,
              padding: EdgeInsets.only(right: 20),
              scrollDirection: Axis.horizontal,
              child: Stack(
                children: [
                  Container(
                    
                    width: graphWidth,
                  ),
                              BottomTitlesRow(
          records: widget.records,
          graphWidth: graphWidth,
          bottomTitlesHeight: bottomTitlesHeight),
                  ...graphWidgetsList
                ],
                //SideTitles widget

                clipBehavior: Clip.none,
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}

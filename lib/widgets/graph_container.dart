import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:new_app/utils/format_weight.dart';
import 'package:new_app/utils/render_graph.dart';
import 'package:new_app/widgets/custom_graph/bottom_titles.dart';
import 'package:new_app/widgets/custom_graph/gradient_fill.dart';
import 'package:new_app/widgets/custom_graph/horizontal_lines.dart';
import 'package:new_app/widgets/custom_graph/lines.dart';
import 'package:new_app/widgets/custom_graph/side_titles.dart';
import 'package:new_app/widgets/custom_graph/spots.dart';
import 'package:new_app/widgets/neumorphic/neumorphic_border_container.dart';

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

  late LinkedScrollControllerGroup _controllers;
  ScrollController _graphController = ScrollController();
  ScrollController _bottomTitlesController = ScrollController();

  @override
  void initState() {
    super.initState();

    //scrolling controllers for bottom titles and graph
    _controllers = LinkedScrollControllerGroup();
    _graphController = _controllers.addAndGet();
    _bottomTitlesController = _controllers.addAndGet();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_graphController.hasClients && widget.records.length >= 8)
        _controllers.jumpTo(_graphController.position.maxScrollExtent);
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

    //print('minDisplayedWeight: $minDisplayedWeight');

    double yHeight = MediaQuery.of(widget.context).size.height / 2;

    /*   double yPxPerKg = (maxDisplayedWeight - minDisplayedWeight) / yHeight;
    print("yPxPerKg: $yPxPerKg"); */
    double xWidth = widget.records.length > 8
        ? MediaQuery.of(widget.context).size.width * (widget.records.length / 8)
        : MediaQuery.of(widget.context).size.width;

        

    double lowerThirdScale = (minWeight - minDisplayedWeight) /
        (maxDisplayedWeight - minDisplayedWeight);

    double scale = 3 * lowerThirdScale;

    List<int> sideTitleWeights = [];

    double one5thOfTheHeight = (yHeight / 5);

    for (int i = 1; i < 5; i++) {
      sideTitleWeights.add(
          findWeight(one5thOfTheHeight * i, maxDisplayedWeight, yHeight)
              .ceil());
    }
    sideTitleWeights.add(maxDisplayedWeight.ceil());

    List<GraphSpot> spots = renderSpots(widget.records, yHeight,
        maxDisplayedWeight, paddingLeft, _selectedIndex, onGraphSpotTap);

    List<DrawLines> graphLines = renderLines(yHeight , MediaQuery.of(widget.context).size.width, spots);

    List<DrawHorizontalLines> horizontalGuidelines = renderHorizontalLines(
        xWidth, yHeight, maxDisplayedWeight, sideTitleWeights);

    List<GFCoordinates> gradientFillBelowGraphCoordinates =
        renderGradientFill(spots);

    List<Widget> graphWidgetsList = [
      ...horizontalGuidelines,
       PaintFill(
          fillCoordinates: gradientFillBelowGraphCoordinates,
          yHeight: yHeight ),
      ...graphLines,
      ...spots,
    ];

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      //bottom titles widget
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* SizedBox(width: MediaQuery.of(context).size.width / 10), */
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
                controller: _bottomTitlesController,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 10),
                child: BottomTitles(records: widget.records, xWidth: xWidth)),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //graph widget
          Container(
            width: xWidth,
            height: yHeight,
            child: SingleChildScrollView(
              controller: _graphController,
              padding: EdgeInsets.only(right: 20),
              scrollDirection: Axis.horizontal,
              child: Container(
                width: xWidth,
                child: Stack(
                  children: [
                    Container(
                        height: yHeight,
                        width: MediaQuery.of(context).size.width / 10,
                        child: SideTitles(
                          sideTitleWeights: sideTitleWeights,
                          yHeight: yHeight,
                          maxDisplayedWeight: maxDisplayedWeight,
                        )),
                    ...graphWidgetsList
                  ],
                  //SideTitles widget
    
                  clipBehavior: Clip.none,
                ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}

/* import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:new_app/utils/render_graph.dart';
import 'package:new_app/widgets/custom_graph/bottom_titles.dart';

import 'package:new_app/widgets/custom_graph/side_titles.dart';
import 'package:provider/provider.dart';

class MyGraph extends StatefulWidget {
  final List<Widget> graphList;
/*  */
  MyGraph({required this.graphList});

  @override
  _MyGraphState createState() => _MyGraphState();
}

class _MyGraphState extends State<MyGraph> {
  late LinkedScrollControllerGroup _controllers;
  ScrollController _graphController = ScrollController();
  ScrollController _bottomTitlesController = ScrollController();

  late List<Widget> graphList;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _graphController = _controllers.addAndGet();
    _bottomTitlesController = _controllers.addAndGet();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_graphController.hasClients)
        _controllers.jumpTo(_graphController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Graph>(builder: (context, graph, child) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: graph.yHeight,
              width: MediaQuery.of(context).size.width / 10,
              //child: SideTitles()),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: graph.yHeight,
              child: SingleChildScrollView(
                controller: _graphController,
                padding: EdgeInsets.only(right: 20),
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: graph.xWidth,
                  child: Stack(
                    children: widget.graphList,
                    clipBehavior: Clip.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width / 10),
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  controller: _bottomTitlesController,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(right: 20),
                  //child: BottomTitles()),
                )),
          ],
        ),
      ]);
    });
  }
}
 */
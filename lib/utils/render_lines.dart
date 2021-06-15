import 'package:new_app/widgets/custom_graph/lines.dart';
import 'package:new_app/utils/indexed_iterables.dart';
import 'package:new_app/widgets/custom_graph/spots.dart';

List<DrawLines> renderLines(List<GraphSpot> spots, double yHeight) {
  List pairs = splitPairs(spots);
  List<DrawLines> lines = [];

  pairs.forEach((pair) {
    if (pair.length == 2) {
      lines.add(DrawLines(
          lineCoordinates: Coordinates(
              startCoords: CoordValues(x: pair[0].x, y: pair[0].y),
              endCoords: CoordValues(x: pair[1].x, y: pair[1].y)),
          yHeight: yHeight));
    }
  });

  //print("lines: $lines");
  return lines;
}

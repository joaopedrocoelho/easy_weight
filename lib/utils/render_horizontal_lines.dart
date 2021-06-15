import 'package:new_app/utils/database.dart';
import 'package:new_app/utils/format_weight.dart';
import 'package:new_app/utils/indexed_iterables.dart';
import 'package:new_app/widgets/custom_graph/horizontal_lines.dart';

late List<Map<String, dynamic>> records;
late double weight;
late int minWeight;
late int maxWeight;
late int fator;
late int paddingTop;
late int paddingBottom;
late double yPxPerKg;

List<DrawHorizontalLines> renderHorizontalLines(
    List<Map<String, dynamic>> records, double graphWidth, double yHeight) {
  minWeight = findMinWeight(records).toInt();
  maxWeight = findMaxWeight(records).toInt();
  fator = ((maxWeight - minWeight) / 6).ceil();
  paddingTop = fator;
  paddingBottom =
      ((fator - minWeight).ceil() > 10) ? (fator - minWeight).ceil() : 10;

  yPxPerKg = yHeight / ((maxWeight + paddingTop) - (minWeight - paddingBottom));

  List<int> weights = [];

  for (int i = minWeight; i <= maxWeight + paddingTop; i += fator) {
    weights.add(i);
  }

  List<DrawHorizontalLines> horizontalLines = weights.map((weight) {
    return DrawHorizontalLines(
        graphWidth: graphWidth, lineHeight: yPos(weight.toDouble()));
  }).toList();

  return horizontalLines;
}

double yPos(double weight) {
  double result = (weight - (minWeight - paddingBottom)) * yPxPerKg;
  //print('yPos: $result');
  return limitDecimals(result, 2);
}

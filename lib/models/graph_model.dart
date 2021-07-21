import 'package:flutter/material.dart';
import 'package:new_app/models/weight_record.dart';

import 'package:new_app/utils/format_weight.dart';
import 'package:new_app/utils/render_graph.dart';
import 'package:new_app/utils/indexed_iterables.dart';

class GraphModel extends ChangeNotifier {
//stateful
  List<WeightRecord> records = [];
  double minWeight = 0;
  double maxWeight = 0;
  int minWeightIndex = 0;
  int maxWeightIndex = 0;
  double minDisplayedWeight = 0;
  double maxDisplayedWeight = 0;
  double yPxPerKg = 0;
  double yHeight = 0;
  double xWidth = 0;
  //List<int> sideTitleWeights
  double lowerThirdScale = 0;
  double range = 0;
  double scale = 0;

//stateless
  int paddingTop = 20;
  int paddingBottom = 40;
  int paddingLeft = 8;

//unknown

  late int fator;

  set newRecords(List<WeightRecord> newRecords) {
    records = newRecords;
    notifyListeners();
  }

  void updateGraph(List<WeightRecord> newRecords, BuildContext context) {
    records = newRecords;

    minWeight = findMinWeight(records);
    maxWeight = findMaxWeight(records);
    minWeightIndex = getMinWeightIndex(records);
    maxWeightIndex = getMaxWeightIndex(records);
    range = maxWeight - minWeight;

    xWidth = records.length > 8
        ? MediaQuery.of(context).size.width * (records.length / 8)
        : MediaQuery.of(context).size.width;

    fator = ((maxWeight - minWeight) / 6).ceil();

    maxDisplayedWeight = setMaxDisplayedWeight(range, maxWeight);
    minDisplayedWeight = setMinDisplayedWeight(minWeight, maxDisplayedWeight);
    lowerThirdScale = (minWeight - minDisplayedWeight) /
        (maxDisplayedWeight - minDisplayedWeight);
    scale = 3 * lowerThirdScale;

    yPxPerKg = (maxDisplayedWeight - minDisplayedWeight) / yHeight;
    /* for (int i = minWeight.ceil(); i <= maxWeight + paddingTop; i += fator) {
      sideTitleWeights.add(i);
    } */

    notifyListeners();
  }

  GraphModel(List<WeightRecord> newRecords, BuildContext context) {
    newRecords.isNotEmpty ? updateGraph(newRecords, context) : records = [];
    notifyListeners();
  }
}

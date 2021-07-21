import 'dart:math';
import 'package:new_app/models/weight_record.dart';

List<double> getWeights(List<WeightRecord> records) {
  List<double> weights = records.map<double>((record) {
    return record.weight;
  }).toList();

  //print('getWeights: $weights');
  return weights;
}

double findMinWeight(List<WeightRecord> records) {
  List<double> weights = getWeights(records);

  double minWeight = findMin(weights);
  //print("minWeight: $minWeight");
  return minWeight;
}

int getMinWeightIndex(List<WeightRecord> records) {
  List<double> weights = getWeights(records);
  double minWeight = findMinWeight(records);
  int index = weights.indexOf(minWeight);
  //print("minWeightIndex: $index");
  return index;
}

double findMaxWeight(List<WeightRecord> records) {
  List<double> weights = getWeights(records);

  double maxWeight = findMax(weights);

  return maxWeight;
}

int getMaxWeightIndex(List<WeightRecord> records) {
  List<double> weights = getWeights(records);

  double maxWeight = findMaxWeight(records);

  int index = weights.indexOf(maxWeight);

  return index;
}

double findMin(List<double> numbers) {
  return numbers.reduce(min);
}

double findMax(List<double> numbers) {
  return numbers.reduce(max);
}

/* double minMaxDifference(List<WeightRecord> records) {
  double maxWeight = findMaxWeight(records);
  double minWeight = findMinWeight(records);

  return (maxWeight - minWeight);
} */

double limitDecimals(double number, int decimals) {
  return double.parse((number).toStringAsFixed(decimals));
}

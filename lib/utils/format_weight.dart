import 'dart:math';

List<double> getWeights(List<Map> records) {
  List<double> weights = records.map<double>((record) {
    return record['weight'];
  }).toList();

  return weights;
}

double findMinWeight(List<Map> records) {
  List<double> weights = records.map<double>((record) {
    return record['weight'];
  }).toList();

  double minWeight = findMin(weights);
  //print("minWeight: $minWeight");
  return minWeight;
}

int minWeightIndex(List<Map> records) {
  List<double> weights = records.map<double>((record) {
    return record['weight'];
  }).toList();

  double minWeight = findMinWeight(records);

  int index = weights.indexOf(minWeight);
  //print("minWeightIndex: $index");
  return index;
}

double findMaxWeight(List<Map> records) {
  List<double> weights = records.map<double>((record) {
    return record['weight'];
  }).toList();

  double maxWeight = findMax(weights);

  return maxWeight;
}

int maxWeightIndex(List<Map> records) {
  List<double> weights = records.map<double>((record) {
    return record['weight'];
  }).toList();

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

double minMaxDifference(List<Map> records) {
  double maxWeight = findMaxWeight(records);
  double minWeight = findMinWeight(records);

  return (maxWeight - minWeight);
}

double limitDecimals(double number, int decimals) {
  return double.parse((number).toStringAsFixed(decimals));
}

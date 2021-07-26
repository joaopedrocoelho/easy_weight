import 'package:new_app/models/weight_record.dart';

import 'package:new_app/utils/format_weight.dart';

double renderCurrentWeight(List<WeightRecord> records) {
  double lastRecordedWeight = records.last.weight;

  return limitDecimals(lastRecordedWeight, 1);
}

double renderWeekTrend(List<WeightRecord> records) {
  DateTime today = DateTime.now();
  DateTime oneWeekBefore = today.subtract(Duration(days: 7));
  double currentWeight = renderCurrentWeight(records);

  //print("oneWeekBefore: $oneWeekBefore");
  List<WeightRecord> recordsOfThisWeek = [...records];
  recordsOfThisWeek
      .removeWhere((record) => record.date.isBefore(oneWeekBefore));

  double thisWeekMaxWeight = findMaxWeight(recordsOfThisWeek);

  //print('thisWeekMaxWeight: $thisWeekMaxWeight');
  //print('currentWeight: $currentWeight');

  double average = currentWeight - thisWeekMaxWeight;

  return limitDecimals(average, 1);
}

double renderMonthTrend(List<WeightRecord> records) {
  DateTime today = DateTime.now();
  DateTime oneMonthBefore = today.subtract(Duration(days: 30));
  double currentWeight = renderCurrentWeight(records);

  List<WeightRecord> recordsOfThisMonth = [...records];

  recordsOfThisMonth
      .removeWhere((record) => record.date.isBefore(oneMonthBefore));

  double thisMonthMaxWeight = findMaxWeight(recordsOfThisMonth);
  //print('thisMonthMaxWeight: $thisMonthMaxWeight');

  double average = currentWeight - thisMonthMaxWeight;

  return limitDecimals(average, 1);
}

double renderTotal(List<WeightRecord> records) {
  double currentWeight = renderCurrentWeight(records);
  double maxWeight = findMaxWeight(records);

  return limitDecimals(currentWeight - maxWeight, 1);
}

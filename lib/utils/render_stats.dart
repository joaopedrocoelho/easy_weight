import 'package:easy_weight/models/weight_record.dart';

import 'package:easy_weight/utils/format_weight.dart';

double? renderCurrentWeight(List<WeightRecord> records) {
  if (records.isNotEmpty) {
    double lastRecordedWeight = records.last.weight;

    return limitDecimals(lastRecordedWeight, 1);
  } else
    return null;
}

double? renderWeekTrend(List<WeightRecord> records) {
  if (records.isNotEmpty && renderCurrentWeight(records) != null) {
    DateTime currentWeightDate = records.last.date;
    DateTime oneWeekBefore = currentWeightDate.subtract(Duration(days: 7));
    double currentWeight = renderCurrentWeight(records)!;

    //print("oneWeekBefore: $oneWeekBefore");
    List<WeightRecord> recordsOfThisWeek = [...records];
    recordsOfThisWeek
        .removeWhere((record) => record.date.isBefore(oneWeekBefore));

    double thisWeekMaxWeight = findMaxWeight(recordsOfThisWeek);

    //print('thisWeekMaxWeight: $thisWeekMaxWeight');
    //print('currentWeight: $currentWeight');

    double average = currentWeight - thisWeekMaxWeight;

    return limitDecimals(average, 1);
  } else {
    return null;
  }
}

double? renderMonthTrend(List<WeightRecord> records) {
  if (records.isNotEmpty && renderCurrentWeight(records) != null) {
    DateTime currentWeightDate = records.last.date;
    DateTime oneMonthBefore = currentWeightDate.subtract(Duration(days: 30));
    double currentWeight = renderCurrentWeight(records)!;

    List<WeightRecord> recordsOfThisMonth = [...records];

    recordsOfThisMonth
        .removeWhere((record) => record.date.isBefore(oneMonthBefore));

    double thisMonthMaxWeight = findMaxWeight(recordsOfThisMonth);
    //print('thisMonthMaxWeight: $thisMonthMaxWeight');

    double average = currentWeight - thisMonthMaxWeight;

    return limitDecimals(average, 1);
  } else
    return null;
}

double? renderTotal(List<WeightRecord> records) {
  if (records.isNotEmpty) {
    double currentWeight = renderCurrentWeight(records)!;
    double maxWeight = findMaxWeight(records);

    return limitDecimals(currentWeight - maxWeight, 1);
  } else
    return null;
}

import 'package:easy_weight/utils/logger_instace.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_weight/models/weight_record.dart';

class RecordsListModel extends ChangeNotifier {
  List<WeightRecord> records = [];
  List<DateTime> usedDates = [];
  DateTime lastAvailableDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String formattedCurrentDate = '';

  bool isLoading = false;

  void updateRecordsList(List<WeightRecord> newRecords) {
    this.records = newRecords;
    this.usedDates = getUsedDates(this.records);
    this.lastAvailableDate = findLastAvailableDate(usedDates, DateTime.now());
    this.formattedCurrentDate = DateFormat('MM/dd').format(
      this.lastAvailableDate,
    );

    notifyListeners();
  }

  void editRecord(WeightRecord editedRecord) {
    List<WeightRecord> cloneRecords = this.records;
    cloneRecords[findRecordIndex(editedRecord.date)] = editedRecord;

    updateRecordsList(cloneRecords);
  }

  int findRecordIndex(DateTime date) {
    WeightRecord foundRecord =
        this.records.firstWhere((record) => record.date == date);

    return this.records.indexOf(foundRecord);
  }

  void deleteRecord(WeightRecord deletedRecord) {
    List<WeightRecord> cloneRecords = this.records;
    cloneRecords.removeAt(findRecordIndex(deletedRecord.date));

    updateRecordsList(cloneRecords);
  }

  List<DateTime> getUsedDates(List<WeightRecord> records) {
    List<DateTime> newUsedDates = [];

    if (records.isNotEmpty) {
      records.forEach((record) => {newUsedDates.add(record.date)});
    }

    newUsedDates.sort((a, b) {
      return a.compareTo(b);
    });

    return newUsedDates;
  }

  DateTime findLastAvailableDate(
      List<DateTime> usedDates, DateTime currentDate) {
    DateTime lastAvailableDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
        
       // logger.i(lastAvailableDate);
    while (usedDates.contains(lastAvailableDate)) {
      lastAvailableDate = lastAvailableDate.subtract(Duration(days: 1));
    }
    return lastAvailableDate;
  }

  void newFormattedDate(DateTime newDate) {
    formattedCurrentDate = DateFormat('MM/dd').format(newDate);
    notifyListeners();
  }
}

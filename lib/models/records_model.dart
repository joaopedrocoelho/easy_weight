import 'package:flutter/material.dart';
import 'package:new_app/models/weight_record.dart';

class RecordsListModel extends ChangeNotifier {
  List<WeightRecord> records = [];

  void updateRecordsList(List<WeightRecord> newRecords) {
    this.records = newRecords;
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
}

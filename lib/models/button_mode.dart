import 'package:easy_weight/utils/logger_instace.dart';
import 'package:flutter/material.dart';
import 'package:easy_weight/models/weight_record.dart';

class ButtonMode with ChangeNotifier {
  bool isEditing = false;
  int? selectedIndex;
  double weight = 0.0;
  DateTime date = DateTime.now();
  int profileId = -1;
  String note = '';

  double? addWeight;
  String? addNote;

  void setEditing(WeightRecord record) {
    isEditing = true;
    weight = record.weight;
    date = record.date;
    note = record.note;
    profileId = record.profileId;

    logger.i("editing record",record.toJson());

    //print("Editing: $weight, $date, $note, isEditing: $isEditing");
    notifyListeners();
  }

  void setAdd() {
    isEditing = false;
    selectedIndex = null;
    weight = 0.0;
    date = DateTime.now();
    profileId = -1;
    note = '';
    notifyListeners();
    logger.i("leaving editing mode", "isEditing: $isEditing");
  }

  void onGraphSpotTap(int index) {
    selectedIndex == index ? selectedIndex = null : selectedIndex = index;
  }

  void clearData() {
    addWeight = null;
    addNote = null;
    notifyListeners();
  }
}//
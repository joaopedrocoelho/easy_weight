import 'package:flutter/material.dart';
import 'package:easy_weight/models/weight_record.dart';

class ButtonMode with ChangeNotifier {
  bool isEditing = false;
  int? selectedIndex;
  double weight = 0.0;
  DateTime date = DateTime.now();
  String note = '';

  double? addWeight;
  String? addNote;

  void setEditing(WeightRecord record) {
    isEditing = true;
    weight = record.weight;
    date = record.date;
    note = record.note;

    //print("Editing: $weight, $date, $note, isEditing: $isEditing");
    notifyListeners();
  }

  void setAdd() {
    isEditing = false;
    selectedIndex = null;
    notifyListeners();
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
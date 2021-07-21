import 'package:flutter/material.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/widgets/custom_graph/spots.dart';

class ButtonMode with ChangeNotifier {
  bool isEditing = false;
  double weight = 0.0;
  DateTime date = DateTime.now();
  String note = '';

  void setEditing(WeightRecord record) {
    isEditing = true;
    weight = record.weight;
    date = record.date;
    note = record.note;

    print("Editing: $weight, $date, $note, isEditing: $isEditing");
    notifyListeners();
  }

  void setAdd() {
    isEditing = false;
    notifyListeners();
  }
}//
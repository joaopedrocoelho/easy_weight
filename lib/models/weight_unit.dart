import 'package:flutter/material.dart';
import 'package:new_app/models/weight_record.dart';

class WeightUnit with ChangeNotifier {
  bool usePounds = false; //2,20462

  void setKilograms() {
    usePounds = false;
    notifyListeners();
  }

  void setPounds() {
    usePounds = true;
    notifyListeners();
  }
}//
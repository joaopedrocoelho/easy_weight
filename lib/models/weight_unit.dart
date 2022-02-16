import 'package:easy_weight/models/user_settings.dart';
import 'package:flutter/material.dart';


class WeightUnit with ChangeNotifier {
  bool usePounds = false; //2,20462

  WeightUnit(Unit unit) {
    if (unit == Unit.imperial) {
      usePounds = true;
    }
  }

  void setKilograms() {
    usePounds = false;
    UserSettings.setUnit(Unit.metric);
    notifyListeners();
  }

  void setPounds() {
    usePounds = true;
    UserSettings.setUnit(Unit.imperial);
    notifyListeners();
  }
}//
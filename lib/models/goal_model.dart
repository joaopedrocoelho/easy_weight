import 'package:flutter/cupertino.dart';
import 'package:easy_weight/models/db/goal_table.dart';

class Goal {
  double weight;
  double initialWeight;

  Goal({required this.weight, required this.initialWeight});

  Map<String, Object> toJson() => {
        GoalFields.weight: weight,
        GoalFields.initialWeight: initialWeight,
        GoalFields.id: 1
      };
}

class GoalModel extends ChangeNotifier {
  Goal? currentGoal;
  bool isEditingGoal = false;

  GoalModel({
    this.currentGoal,
  });

  void editGoal() {
    isEditingGoal = true;
    notifyListeners();
  }

  void updateGoalRecord(Goal goal) {
    currentGoal = goal;
    notifyListeners();
  }

  void addGoalRecord(Goal goal) {
    currentGoal = goal;
    notifyListeners();
  }
}

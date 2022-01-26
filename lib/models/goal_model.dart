import 'package:easy_weight/utils/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_weight/models/db/goal_table.dart';

class Goal {
  double weight;
  double initialWeight;
  int profileId;

  Goal({required this.weight, required this.initialWeight, required this.profileId});

  Map<String, Object> toJson() => {
        GoalFields.weight: weight,
        GoalFields.initialWeight: initialWeight,
        GoalFields.profileId: profileId,
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

  void getGoal(int profileId) async {
    await RecordsDatabase.instance.getGoal(profileId).then((goal) {
      currentGoal = goal;
      notifyListeners();
    });
  }

  
}

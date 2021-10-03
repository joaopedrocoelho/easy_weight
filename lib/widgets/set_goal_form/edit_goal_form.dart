import 'package:flutter/material.dart';
import 'package:new_app/models/goal_model.dart';
import 'package:new_app/models/records_model.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/models/weight_unit.dart';
import 'package:new_app/utils/render_stats.dart';

import 'package:new_app/widgets/add_record_form/neu_close_button.dart';

import 'package:new_app/widgets/buttons/cancel_button.dart';
import 'package:new_app/widgets/buttons/save_button.dart';

import 'package:new_app/utils/database.dart';
import 'package:new_app/widgets/edit_record_form/edit_weight.dart';

import 'package:provider/provider.dart';

import 'package:new_app/widgets/add_record_form/neu_form_container.dart';

class EditGoal extends StatefulWidget {
  final AnimationController animationController;
  final VoidCallback setVisible;
  final VoidCallback setInvisible;

  EditGoal({
    required this.animationController,
    required this.setVisible,
    required this.setInvisible,
  });

  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal>
    with SingleTickerProviderStateMixin {
  late FocusNode hintFocus;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  //form fields state
  double _goal = 0.0;
  double _initialWeight = 0.0;

  Future addGoal() async {
    Goal newGoal = Goal(weight: _goal, initialWeight: _initialWeight);
    await RecordsDatabase.instance.addGoal(newGoal);
    print("goal $_goal $_initialWeight");
    widget.setInvisible();
  }

  Future updateGoal() async {
    Goal newGoal = Goal(weight: _goal, initialWeight: _initialWeight);
    await RecordsDatabase.instance.updateGoal(newGoal);
    print("goal $_goal $_initialWeight");

    widget.setInvisible();
  }

  @override
  void initState() {
    super.initState();

    hintFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    hintFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GoalModel, WeightUnit>(
        builder: (context, goalModel, unit, child) {
      FocusScopeNode currentFocus = FocusScope.of(context);

      return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
              parent: widget.animationController, curve: Curves.ease)),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: NeuFormContainer(
              height: 200,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Set a goal',
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.start,
                        ),
                        NeuCloseButton(onPressed: widget.setInvisible)
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    EditWeightTextField(
                        hintFocus: hintFocus,
                        initialValue: goalModel.currentGoal != null
                            ? goalModel.currentGoal!.weight.toString()
                            : _goal.toString(),
                        onSaved: (value) {
                          unit.usePounds
                              ? setState(() {
                                  print('hey pound');
                                  _goal = (double.parse(value!) / 2.20462)
                                      .ceilToDouble();
                                })
                              : setState(() {
                                  _goal = double.parse(value!);
                                });
                        }),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: CancelButton(onPressed: () {
                          setState(() {
                            if (goalModel.currentGoal != null) {
                              _goal = goalModel.currentGoal!.weight;
                            } else {
                              _goal = 0.0;
                            }
                          });
                          widget.setInvisible();
                        })),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(child: SaveButton(onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.

                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            List<WeightRecord> records =
                                context.read<RecordsListModel>().records;
                            //need to update initialWeight to currentWeight
                            setState(() {
                              _initialWeight = renderCurrentWeight(records)!;
                              print('_initialWeight $_initialWeight');
                            });

                            Goal newGoal = Goal(
                                weight: _goal, initialWeight: _initialWeight);

                            if (goalModel.currentGoal != null) {
                              Provider.of<GoalModel>(context, listen: false)
                                  .updateGoalRecord(newGoal);
                              updateGoal();
                            } else {
                              Provider.of<GoalModel>(context, listen: false)
                                  .addGoalRecord(newGoal);
                              addGoal();
                            }

                            currentFocus.focusedChild?.unfocus();
                          }
                        }))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }
}

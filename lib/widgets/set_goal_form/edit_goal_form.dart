import 'package:easy_weight/utils/convert_unit.dart';
import 'package:easy_weight/utils/logger_instace.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/goal_model.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/models/weight_unit.dart';
import 'package:easy_weight/utils/render_stats.dart';

import 'package:easy_weight/widgets/add_record_form/neu_close_button.dart';

import 'package:easy_weight/widgets/buttons/cancel_button.dart';
import 'package:easy_weight/widgets/buttons/save_button.dart';

import 'package:easy_weight/utils/database.dart';
import 'package:easy_weight/widgets/edit_record_form/edit_weight.dart';

import 'package:provider/provider.dart';

import 'package:easy_weight/widgets/add_record_form/neu_form_container.dart';

class EditGoal extends StatefulWidget {
  final int profileId;

  EditGoal({required this.profileId});

  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal>
    with SingleTickerProviderStateMixin {
  late FocusNode hintFocus;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late AnimationController _controller;

  //form fields state
  double _goal = 0.0;
  double _initialWeight = 0.0;

  Future addGoal() async {
    Goal newGoal = Goal(
        weight: _goal,
        initialWeight: _initialWeight,
        profileId: widget.profileId);
    await RecordsDatabase.instance.addGoal(newGoal);
  }

  Future updateGoal() async {
    Goal newGoal = Goal(
        weight: _goal,
        initialWeight: _initialWeight,
        profileId: widget.profileId);
    await RecordsDatabase.instance.updateGoal(newGoal);
    logger.i("goal $_goal $_initialWeight");
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _controller.forward();
    hintFocus = FocusNode();

    logger.i("Profile id at goal form is: ${widget.profileId}");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    hintFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GoalModel, WeightUnit>(
        builder: (context, goalModel, unit, child) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      final theme = NeumorphicTheme.of(context);

      return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease)),
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
                          AppLocalizations.of(context)!.addGoal,
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.start,
                        ),
                        NeuCloseButton(onPressed: () {
                          _controller.reverse();
                          Navigator.pop(context);
                        })
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
                          setState(() {
                            unit.usePounds
                                ? _goal = lbsToKg(double.parse(value!))
                                : _goal = double.parse(value!);
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
                                weight: _goal,
                                initialWeight: _initialWeight,
                                profileId: widget.profileId);

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
                            _controller.reverse();
                            Navigator.pop(context);
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

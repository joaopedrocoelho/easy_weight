import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/widgets/buttons/menu_button.dart';
import 'package:easy_weight/widgets/drawer/drawer_scaffold_widget.dart';
import 'package:easy_weight/widgets/drawer/drawer_widget.dart';
import 'package:easy_weight/widgets/profiles/profile_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/button_mode.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/utils/format_date.dart';
import 'package:easy_weight/utils/render_stats.dart';
import 'package:easy_weight/widgets/buttons/edit_buttons.dart';
import 'package:easy_weight/widgets/change_unit/unit_toggle.dart';
import 'package:easy_weight/widgets/custom_graph/empty_graph_container.dart';
import 'package:easy_weight/widgets/goal/disabled_goal.dart';
import 'package:easy_weight/widgets/goal/goal_stats_container.dart';
import 'package:easy_weight/widgets/goal/progress_circle/circle_container_test.dart';
import 'package:easy_weight/widgets/goal/progress_circle/outer_wheel.dart';
import 'package:easy_weight/widgets/graph_container.dart';
import 'package:easy_weight/widgets/set_goal_form/edit_goal_form.dart';

import 'package:easy_weight/widgets/stats/current_weight_stats.dart';

import 'package:provider/provider.dart';

import 'package:easy_weight/widgets/add_record_form/add_record_form.dart';
import 'package:easy_weight/widgets/edit_record_form/edit_record_form.dart';

class Home extends StatefulWidget {
  final List<WeightRecord> list;

  Home({required this.list});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _addController;
  late AnimationController _editController;
  late AnimationController _goalController;

  bool isLoading = false;

  void _setVisible(String form) {
    setState(() {
      if (form == 'add') {
        _addController.forward();
      } else if (form == 'edit') {
        _editController.forward();
      } else {
        _goalController.forward();
      }
    });
  }

  void _setinVisible(String form) {
    setState(() {
      if (form == 'add') {
        _addController.reverse();
      } else if (form == 'edit') {
        _editController.reverse();
      } else {
        _goalController.reverse();
      }
    });
  }

  @override
  void initState() {
    _addController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _editController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _goalController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    super.initState();
  }

  @override
  void dispose() {
    _addController.dispose();
    _editController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    final theme = NeumorphicTheme.currentTheme(context);
    bool isUsingDark = NeumorphicTheme.isUsingDark(context);

    return Consumer3<RecordsListModel, ButtonMode, ProfilesListModel>(
        builder: (context, recordsModel, profilesList, buttonMode, child) {
      final bool mode = context.read<ButtonMode>().isEditing;

      final List<WeightRecord> records =
          context.watch<RecordsListModel>().records;

      records.sort((a, b) {
        return a.date.compareTo(b.date);
      });

      double editWeight = context.watch<ButtonMode>().weight;

      //print('editWeight: $editWeight');

      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        drawer: DrawerScaffoldWidget(),
        
        body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CurrentWeightStats(
                              currentWeight: renderCurrentWeight(records),
                              weekTrend: renderWeekTrend(records),
                              monthTrend: renderMonthTrend(records),
                              allTimeTrend: renderTotal(records),
                            ),
                            records.isNotEmpty
                                ? GoalStatsContainer(
                                    setVisible: () {
                                      _setVisible('goal');
                                    },
                                  )
                                : DisabledGoal()
                          ],
                        ),
                        records.isNotEmpty
                            ? GraphContainer(records: records, context: context)
                            : EmptyGraphContainer(),
                      ],
                    ),
                  ]),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: MenuButton(onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
              },)),

            /* Positioned(
                bottom: 0,
                left: 0,
                child: Container(width: 100, child: UnitToggle())) */
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 100,
                child: EditButtons(
                  onPressed: () {
                    _setVisible(mode ? 'edit' : 'add');
                  },
                ),
              ),
            ),
            EditRecord(
              animationController: _editController,
              setVisible: () {
                _setVisible('edit');
              },
              setInvisible: () {
                currentFocus.focusedChild?.unfocus();
                _setinVisible('edit');
              },
              date: context.watch<ButtonMode>().date,
              weight: editWeight,
              note: context.watch<ButtonMode>().note,
              records: records,
            ),
            AddRecord(
              animationController: _addController,
              setVisible: () {
                _setVisible('add');
              },
              setInvisible: () {
                currentFocus.focusedChild?.unfocus();
                _setinVisible('add');
              },
              
              records: records,
            ),
            EditGoal(
              animationController: _goalController,
              setVisible: () {
                _setVisible('goal');
              },
              setInvisible: () {
                currentFocus.focusedChild?.unfocus();
                _setinVisible('goal');
              },
            )
          ]),
        ),
      );
    });
  }
}

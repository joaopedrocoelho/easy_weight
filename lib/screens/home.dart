import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/widgets/buttons/menu_button.dart';
import 'package:easy_weight/widgets/drawer/drawer_scaffold_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:easy_weight/models/button_mode.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:easy_weight/models/weight_record.dart';

import 'package:easy_weight/utils/render_stats.dart';
import 'package:easy_weight/widgets/buttons/edit_buttons.dart';

import 'package:easy_weight/widgets/custom_graph/empty_graph_container.dart';

import 'package:easy_weight/widgets/goal/goal_stats_container.dart';

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
    //FocusScopeNode currentFocus = FocusScope.of(context);

    return Consumer3<RecordsListModel, ButtonMode, ProfilesListModel>(
        builder: (context, recordsModel, buttonMode, profilesList, child) {
      final bool mode = context.read<ButtonMode>().isEditing;

      final List<WeightRecord> records =
          context.watch<RecordsListModel>().records;

      records.sort((a, b) {
        return a.date.compareTo(b.date);
      });

      double editWeight = context.watch<ButtonMode>().weight;

      void _setVisible(String form) {
        if (form == 'edit') {
          showDialog(
              context: context,
              builder: (context) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: EditRecord(
                    date: context.watch<ButtonMode>().date,
                    weight: editWeight,
                    note: context.watch<ButtonMode>().note,
                    records: records,
                  ),
                  
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: AddRecord(
                    records: records,
                  ),
                );
              });
        }
      }

      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: DrawerScaffoldWidget(),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                fit: FlexFit.loose,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 5,
                      child: CurrentWeightStats(
                        currentWeight: renderCurrentWeight(records),
                        weekTrend: renderWeekTrend(records),
                        monthTrend: renderMonthTrend(records),
                        allTimeTrend: renderTotal(records),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 6,
                      child: GoalStatsContainer(
                        setVisible: () {
                          records.isNotEmpty
                              ? showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Scaffold(
                                      
                                      backgroundColor: Colors.transparent,
                                      body: EditGoal(
                                        profileId:
                                            profilesList.selectedProfileID,
                                      ),
                                    );
                                  })
                              : null;
                        },
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 7,
                  child: records.isNotEmpty
                      ? GraphContainer(records: records, context: context)
                      : EmptyGraphContainer()),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MenuButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        EditButtons(
                          onPressed: () {
                            _setVisible(mode ? 'edit' : 'add');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

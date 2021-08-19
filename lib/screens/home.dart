import 'package:flutter/material.dart';
import 'package:new_app/models/button_mode.dart';
import 'package:new_app/models/records_model.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/utils/format_date.dart';
import 'package:new_app/utils/render_stats.dart';
import 'package:new_app/widgets/buttons/edit_buttons.dart';
import 'package:new_app/widgets/change_unit/unit_toggle.dart';
import 'package:new_app/widgets/custom_graph/empty_graph_container.dart';
import 'package:new_app/widgets/graph_container.dart';

import 'package:new_app/widgets/stats/current_weight_stats.dart';

import 'package:provider/provider.dart';

import 'package:new_app/widgets/add_record_form/add_record_form.dart';
import 'package:new_app/widgets/edit_record_form/edit_record_form.dart';



class Home extends StatefulWidget {
  final List<WeightRecord> list;

  Home({required this.list});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _addController;
  late AnimationController _editController;
  bool isLoading = false;

  void _setVisible(String form) {
    setState(() {
      if (form == 'add') {
        _addController.forward();
      } else {
        _editController.forward();
      }
    });
  }

  void _setinVisible(String form) {
    setState(() {
      if (form == 'add') {
        _addController.reverse();
      } else {}
      _editController.reverse();
    });
  }

  @override
  void initState() {
    _addController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _editController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    super.initState();
  }

  @override
  void dispose() {
    _addController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RecordsListModel, ButtonMode>(
        builder: (context, recordsModel, buttonMode, child) {
      final bool mode = context.read<ButtonMode>().isEditing;

      final List<WeightRecord> records =
          context.watch<RecordsListModel>().records;

      records.sort((a, b) {
        return a.date.compareTo(b.date);
      });

      double editWeight = context.watch<ButtonMode>().weight;

      //print('editWeight: $editWeight');

     

    
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /* RecordsListView(records: recordsModel.records), */
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CurrentWeightStats(
                          currentWeight: renderCurrentWeight(records),
                          weekTrend: renderWeekTrend(records),
                          monthTrend: renderMonthTrend(records),
                          allTimeTrend: renderTotal(records),
                        ),
                        records.isNotEmpty
                            ? GraphContainer(records: records, context: context)
                            : EmptyGraphContainer(),
                      ],
                    ),
                  ]),
            ),
            Positioned(
              bottom:0,
              left: 0,
              child: Container(
                width: 100,
               
                child: UnitToggle())),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 100,
                child: EditButtons(
                  addOnPressed: () {
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
                _setinVisible('add');
              },
              setRefresh: () {},
              records: records,
            ),
          ]),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:new_app/models/button_mode.dart';
import 'package:new_app/models/records_model.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/widgets/buttons/edit_buttons.dart';
import 'package:new_app/widgets/graph_container.dart';
import 'package:new_app/widgets/list-view/records_list_view.dart';
import 'package:new_app/widgets/stats/current_weight_stats.dart';
import 'package:new_app/widgets/stats/stats_container.dart';
import 'package:provider/provider.dart';

import 'package:new_app/widgets/add_record_form.dart';
import 'package:new_app/widgets/edit_record_form.dart';

class Home extends StatefulWidget {
  final List<WeightRecord> list;

  Home({required this.list});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isLoading = false;
  bool _isAddFormVisible = false;
  bool _isEditFormVisible = false;

  void _setVisible(String form) {
    setState(() {
      if (form == 'add') {
        _isAddFormVisible = true;
      } else {
        _isEditFormVisible = true;
      }
      _animationController.forward();
    });
  }

  void _setinVisible(String form) {
    setState(() {
      if (form == 'add') {
        _isAddFormVisible = false;
      } else {
        _isEditFormVisible = false;
      }
      _animationController.reverse();
    });
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RecordsListModel, ButtonMode>(
        builder: (context, recordsModel, buttonMode, child) {
      final bool mode = context.read<ButtonMode>().isEditing;

      return Scaffold(
        body: Stack(
          children:[ Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* RecordsListView(records: recordsModel.records), */
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CurrentWeightStats(),
                      recordsModel.records.isNotEmpty
                          ? GraphContainer(
                              records: recordsModel.records, context: context)
                          : Text('empty'),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 20),
                          child: EditButtons(
                            addOnPressed: () {
                              _setVisible(mode ? 'edit' : 'add');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
               
              ]),
               context.watch<ButtonMode>().isEditing
                    ? EditRecord(
                        animationController: _animationController,
                        visible: _isEditFormVisible,
                        setVisible: () {
                          _setVisible('edit');
                        },
                        setInvisible: () {
                          _setinVisible('edit');
                        },
                        setRefresh: () {},
                        date: context.read<ButtonMode>().date,
                        weight: context.read<ButtonMode>().weight,
                        note: context.read<ButtonMode>().note,
                      )
                    : AddRecord(
                        animationController: _animationController,
                        visible: _isAddFormVisible,
                        setVisible: () {
                          _setVisible('add');
                        },
                        setInvisible: () {
                          _setinVisible('add');
                        },
                        setRefresh: () {}),
          ]),
      );
    });
  }
}

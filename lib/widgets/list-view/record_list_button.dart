import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:new_app/models/button_mode.dart';
import 'package:provider/provider.dart';

class RecordListButton extends StatefulWidget {
  final DateTime date;
  final double weight;
  final String note;
  final bool selected;
  final int id;
  final VoidCallback onGraphSpotTap;

  const RecordListButton(
      {Key? key,
      required this.date,
      required this.weight,
      required this.note,
      required this.selected,
      required this.id,
      required this.onGraphSpotTap})
      : super(key: key);

  @override
  _RecordListButtonState createState() => _RecordListButtonState();
}

class _RecordListButtonState extends State<RecordListButton> {
  Color _color = Colors.lightBlue;
  Color _selectedColor = Colors.lightGreen;

  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonMode>(builder: (context, mode, child) {
      return Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          child: GestureDetector(
              onTap: () {
                widget.onGraphSpotTap();
                !widget.selected
                    ? mode.setEditing(WeightRecord(
                        date: widget.date,
                        weight: widget.weight,
                        note: widget.note))
                    : mode.setAdd();
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(DateFormat('MM/dd').format(
                        widget.date,
                      )),
                      SizedBox(
                        width: 10,
                        height: 1,
                      ),
                      Text('${widget.weight}'),
                      SizedBox(
                        width: 10,
                        height: 1,
                      ),
                      Text('${widget.note}')
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    color: widget.selected ? _selectedColor : _color,
                    borderRadius: BorderRadius.circular(12)),
              )));
    });
  }
}

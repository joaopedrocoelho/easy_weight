import 'package:intl/intl.dart';
import 'package:easy_weight/models/db/records_table.dart';

class WeightRecord {
  final DateTime date;
  final double weight;
  final String note;
  final int profileId;

  const WeightRecord(
      {required this.date, required this.weight, this.note = '', required this.profileId});

  Map<String, Object> toJson() => {
        RecordFields.date: DateFormat('yyyy-MM-dd').format(date).toString(),
        RecordFields.weight: weight,
        RecordFields.note: note,
        RecordFields.profileId: profileId,
      };
}

List<WeightRecord> toWeightRecordList(List<Map<String, dynamic>> records) {
  return records.map((record) {
    return WeightRecord(
        date: DateTime.parse(record[RecordFields.date]),
        weight: record[RecordFields.weight],
        note: record[RecordFields.note],
        profileId: record[RecordFields.profileId]);
  }).toList();
}

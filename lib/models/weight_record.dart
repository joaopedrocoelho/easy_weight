import 'package:intl/intl.dart';

final String tableRecords = 'records';

class RecordFields {
  static final String date = 'record_date';
  static final String weight = 'weight';
  static final String note = 'note';
}

class WeightRecord {
  final DateTime date;
  final double weight;
  final String note;

  const WeightRecord(
      {required this.date, required this.weight, this.note = ''});

  Map<String, Object> toJson() => {
        RecordFields.date: DateFormat('yyyy-MM-dd').format(date).toString(),
        RecordFields.weight: weight,
        RecordFields.note: note
      };
}

List<WeightRecord> toWeightRecordList(List<Map<String, dynamic>> records) {
  return records.map((record) {
    return WeightRecord(
        date: DateTime.parse(record[RecordFields.date]),
        weight: record[RecordFields.weight],
        note: record[RecordFields.note]);
  }).toList();
}

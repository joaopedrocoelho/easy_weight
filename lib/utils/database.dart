import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:new_app/models/weight_record.dart';
import 'package:intl/intl.dart';

class RecordsDatabase {
  RecordsDatabase._privateConstructor();
  //make it a singleton class
  static final RecordsDatabase instance = RecordsDatabase._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('records.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    db.execute('''
      CREATE TABLE $tableRecords (
        ${RecordFields.date} TEXT NOT NULL,
        ${RecordFields.weight} DOUBLE NOT NULL,
        ${RecordFields.note} TEXT NULL
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<int> addRecord(WeightRecord record) async {
    final db = await instance.database;

    final id = await db.insert(tableRecords, record.toJson());

    print('record id : $id');
    return id;
  }

  Future<List<WeightRecord>> getRecords() async {
    final db = await instance.database;

    print("db: $db");

    List<Map<String, dynamic>> records = await db.rawQuery(
        'SELECT * FROM $tableRecords ORDER BY date(${RecordFields.date}) ASC');

    List<WeightRecord> recordsConverted = toWeightRecordList(records);

    recordsConverted.forEach((record) {
      print('record: ${record.date} - ${record.weight} - ${record.note}');
    });

    return recordsConverted;
  }

  Future<int> updateRecord(WeightRecord record) async {
    final db = await instance.database;

    String date = DateFormat('yyyy-MM-dd').format(record.date).toString();
    print("record.date:${record.date}");
    print("date: $date");

    return db.update(
      tableRecords,
      record.toJson(),
      where: '${RecordFields.date} = ?',
      whereArgs: [date],
    );
  }

  Future<int> delete(WeightRecord record) async {
    final db = await instance.database;

    String date = DateFormat('yyyy-MM-dd').format(record.date).toString();

    return db.delete(
      tableRecords,
      where: '${RecordFields.date} = ?',
      whereArgs: [date],
    );
  }

  /// Generate a modifiable result set

}

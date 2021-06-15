import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:new_app/models/records.dart';

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

  Future<List<Map<String, dynamic>>> getRecords() async {
    final db = await instance.database;
    List<Map<String, dynamic>> records = await db.rawQuery(
        'SELECT * FROM $tableRecords ORDER BY date(${RecordFields.date}) ASC');

    print('records: $records');
    return records;
  }
}

/// Generate a modifiable result set
List<Map<String, dynamic>> makeModifiableResults(
    List<Map<String, dynamic>> results) {
  // Generate modifiable
  return List<Map<String, dynamic>>.generate(
      results.length, (index) => Map<String, dynamic>.from(results[index]),
      growable: true);
}

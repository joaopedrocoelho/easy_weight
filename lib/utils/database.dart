import 'package:easy_weight/models/db/profiles_table.dart';
import 'package:easy_weight/models/db/records_table.dart';
import 'package:easy_weight/models/db/goal_table.dart';
import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:easy_weight/models/weight_record.dart';
import 'package:easy_weight/models/goal_model.dart';
import 'package:easy_weight/utils/indexed_iterables.dart';
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
      CREATE TABLE $profilesTable (
        ${ProfileFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ProfileFields.name} TEXT NULL,
        ${ProfileFields.height} REAL NULL,
        ${ProfileFields.birthday} TEXT NULL,
        ${ProfileFields.emoji} TEXT NULL,
        ${ProfileFields.gender} TEXT NULL,
        ${ProfileFields.color} TEXT NULL
         )
    ''');

    ProfileModel _defaultProfile = ProfileModel(id: 0);

    final int insert = await db.insert(profilesTable, _defaultProfile.toJson());

    print("defaultProfile inserted with id: $insert");

    db.execute('''
      CREATE TABLE $recordsTable (
        ${RecordFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${RecordFields.date} TEXT NOT NULL,
        ${RecordFields.weight} DOUBLE NOT NULL,
        ${RecordFields.note} TEXT NULL,
        ${RecordFields.profileId} INTEGER NOT NULL,
        FOREIGN KEY(${RecordFields.profileId}) REFERENCES $profilesTable(${ProfileFields.id})
      )
    ''');

    db.execute('''
      CREATE TABLE $goalTable (
        ${GoalFields.id} INTEGER PRIMARY KEY NOT NULL,
        ${GoalFields.weight} DOUBLE NOT NULL,
        ${GoalFields.initialWeight} DOUBLE NOT NULL,
        ${GoalFields.profileId} INTEGER NOT NULL,
        FOREIGN KEY(${GoalFields.profileId}) REFERENCES $profilesTable(${ProfileFields.id})
      )
    ''');

    print(db.query(goalTable));
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  //profiles

  Future<List<ProfileModel>> getProfiles() async {
    final db = await instance.database;
    

    final profiles = await db.rawQuery(
      'SELECT * FROM $profilesTable ORDER BY ${ProfileFields.id} ASC');

    print("profiles: $profiles");
    List<ProfileModel> profilesConverted =toProfileList(profiles);

    return profilesConverted;
  }

  Future<int> addProfile(ProfileModel profile) async {
    final db = await instance.database;

    return await db.insert(profilesTable, profile.toJson());
  }

  Future<int> updateProfile(ProfileModel profile) async {
    final db = await instance.database;

    return await db.update(profilesTable, profile.toJson(), where: '${ProfileFields.id} = ?', whereArgs: [profile.id]);
  }

  Future<int> deleteProfile(int id) async {
    final db = await instance.database;

    return await db.delete(profilesTable, where: '${ProfileFields.id} = ?', whereArgs: [id]);
  }

  //records

  Future<int> addRecord(WeightRecord record) async {
    final db = await instance.database;
   

    final id = await db.insert(recordsTable, record.toJson());

    // print('record id : $id');
    return id;
  }

  Future<List<WeightRecord>> getRecords(int profileId) async {
    final db = await instance.database;
    
    //print("db: $db");

    List<Map<String, dynamic>> records = await db.rawQuery(
      'SELECT * FROM $recordsTable WHERE ${RecordFields.profileId} = $profileId ORDER BY date(${RecordFields.date}) ASC'
      );

    List<WeightRecord> recordsConverted = toWeightRecordList(records);

    recordsConverted.forEach((record) {
      // print('record: ${record.date} - ${record.weight} - ${record.note}');
    });

    return recordsConverted;
  }

  Future<int> updateRecord(WeightRecord record) async {
    final db = await instance.database;

    String date = DateFormat('yyyy-MM-dd').format(record.date).toString();
    //print("record.date:${record.date}");
    // print("date: $date");

    return db.update(
      recordsTable,
      record.toJson(),
      where: '${RecordFields.date} = ? AND ${RecordFields.profileId} = ?',
      whereArgs: [date, record.profileId],
    );
  }

  Future<int> deleteRecord(WeightRecord record) async {
    final db = await instance.database;

    String date = DateFormat('yyyy-MM-dd').format(record.date).toString();

    return db.delete(
      recordsTable,
      where: '${RecordFields.date} = ? AND ${RecordFields.profileId} = ?',
      whereArgs: [date, record.profileId],
    );
  }

  //goal

  Future<int> addGoal(Goal goal) async {
    final db = await instance.database;

    final id = await db.insert(goalTable, goal.toJson());

    // print('record id : $id');
    return id;
  }

  Future<Goal?> getGoal() async {
    final db = await instance.database;

    //print("db: $db");

    List<Map<String, dynamic>> goal = await db.rawQuery(
        'SELECT ${GoalFields.weight}, ${GoalFields.initialWeight} FROM $goalTable WHERE ${GoalFields.id}=1');

    print("goal db $goal");
    late Goal goalConverted;

    if (goal.isNotEmpty) {
      goal.forEachIndexed((goal, index) => {
            if (index == 0)
              {
                goalConverted = Goal(
                    weight: goal[GoalFields.weight],
                    initialWeight: goal[GoalFields.initialWeight])
              }
          });

      return goalConverted;
    } else {
      return null;
    }
  }

  Future<int> updateGoal(Goal goal) async {
    final db = await instance.database;

    return db.update(
      goalTable,
      goal.toJson(),
      where: '${GoalFields.id} = ?',
      whereArgs: [1],
    );
  }

  Future<int> deleteGoal(Goal goal) async {
    final db = await instance.database;

    return db.delete(
      goalTable,
      where: '${GoalFields.id} = ?',
      whereArgs: [1],
    );
  }
}

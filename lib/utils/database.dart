import 'package:easy_weight/models/db/profiles_table.dart';
import 'package:easy_weight/models/db/records_table.dart';
import 'package:easy_weight/models/db/goal_table.dart';
import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/models/profiles_list_model.dart';
import 'package:easy_weight/utils/logger_instace.dart';
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

    return await openDatabase(path,
        version: 2, onCreate: _createDB);
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

    Profile _defaultProfile = Profile(id: 0);

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
        ${GoalFields.date} TEXT NOT NULL,
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

/* //upgrade DB
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
    Future<List<Map<String, Object?>>> records =  db.query(recordsTable);
    Future<List<Map<String, Object?>>> goals =  db.query(goalTable);

    logger.i("old db",records);
    logger.i("old db",goals);

     /*  db.execute('''
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

      Profile _defaultProfile = Profile(id: 0);

      final int insert =
          await db.insert(profilesTable, _defaultProfile.toJson());

      print("defaultProfile inserted with id: $insert");

      db.execute('''
     ALTER TABLE $recordsTable
     ADD COLUMN ${RecordFields.id} INTEGER PRIMARY KEY AUTOINCREMENT
    ''');

      db.execute('''
      ALTER TABLE $recordsTable
      ADD COLUMN ${RecordFields.profileId} INTEGER NOT NULL DEFAULT 0,
      ''');

      db.execute('''
    ALTER TABLE $recordsTable
    ADD COLUMN  FOREIGN KEY(${RecordFields.profileId}) REFERENCES $profilesTable(${ProfileFields.id})
    ''');
 */
    
    }
  } */
  //profiles

  Future<List<Profile>> getProfiles() async {
    final db = await instance.database;

    final profiles = await db.rawQuery(
        'SELECT * FROM $profilesTable ORDER BY ${ProfileFields.id} ASC');

    profiles.forEach((profile) {
      logger.i("PROFILE: ${profile[ProfileFields.name]}", profile);
    });

    List<Profile> profilesConverted = toProfileList(profiles);

    return profilesConverted;
  }

  Future<int> addProfile(Profile profile) async {
    final db = await instance.database;

    return await db.insert(profilesTable, profile.toJson());
  }

  Future<int> updateProfile(Profile profile) async {
    final db = await instance.database;

    return await db.update(profilesTable, profile.toJson(),
        where: '${ProfileFields.id} = ?', whereArgs: [profile.id]);
  }

  Future<int> deleteProfile(int id) async {
    final db = await instance.database;
    await db.delete(recordsTable,
        where: '${RecordFields.profileId} = ?', whereArgs: [id]);
    return await db.delete(profilesTable,
        where: '${ProfileFields.id} = ?', whereArgs: [id]);
  }

  //records

  Future<int> addRecord(WeightRecord record) async {
    final db = await instance.database;

    logger.d("Added record to profile: ${record.profileId}", record.toJson());

    final id = await db.insert(recordsTable, record.toJson());

    // print('record id : $id');
    return id;
  }

  Future<List<WeightRecord>> getRecords(int profileId) async {
    final db = await instance.database;

    //print("db: $db");

    List<Map<String, dynamic>> records = await db.rawQuery(
        'SELECT * FROM $recordsTable WHERE ${RecordFields.profileId} = $profileId ORDER BY date(${RecordFields.date}) ASC');

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

    if (id != -1) {
      logger.i("Goal added with id: $id", goal.toJson());
    }
    return id;
  }

  Future<Goal?> getGoal(int profileId) async {
    final db = await instance.database;

    //print("db: $db");

    List<Map<String, dynamic>> goal = await db.rawQuery(
        'SELECT ${GoalFields.weight}, ${GoalFields.date}, ${GoalFields.initialWeight}, ${GoalFields.profileId} FROM $goalTable WHERE ${GoalFields.profileId}= $profileId');

    logger.i("Getting goal for profile $profileId");
    late Goal goalConverted;

    if (goal.isNotEmpty) {
      goal.forEachIndexed((goal, index) => {
            if (index == 0)
              {
                logger.i("Goal found: ${goal[GoalFields.weight]}", goal),
                goalConverted = Goal(
                    date: DateTime.parse(goal[GoalFields.date]),
                    weight: goal[GoalFields.weight],
                    initialWeight: goal[GoalFields.initialWeight],
                    profileId: goal[GoalFields.profileId])
              }
          });

      return goalConverted;
    } else {
      return null;
    }
  }

  Future<int> updateGoal(Goal goal) async {
    final db = await instance.database;

    logger.i("Updating Goal with id: ${goal.profileId}", goal.toJson());

    return db.update(
      goalTable,
      goal.toJson(),
      where: '${GoalFields.profileId} = ?',
      whereArgs: [goal.profileId],
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

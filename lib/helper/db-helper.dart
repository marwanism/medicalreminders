import 'package:medicalremcs/models/medicine.dart';
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';
import './constants.dart';

class DatabaseHelper {

  DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await initDb();
    return _database!;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), "MedicineData.db");
    String sql = '''
      CREATE TABLE $tableMedicine (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colMedName TEXT NOT NULL,
        $colMedUnit TEXT NOT NULL,
        $colMedDose DOUBLE NOT NULL,
        $colMedDateAdded TEXT NOT NULL,
        $colMedDuration INTEGER NOT NULL,
        $colMedIsActive BOOLEAN NOT NULL,
      );
      CREATE TABLE $tableReminder (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colRemHours INTEGER NOT NULL,
        $colRemMinutes INTEGER NOT NULL,
        $colRemMedicineId INTEGER NOT NULL,
        FOREIGN KEY($colRemMedicineId) REFERENCES $tableMedicine($colId),
      );
    ''';
    openDatabase(
      path, 
      version: 1,
      onCreate: (db, version) async {
        await db.execute(sql);
      }
    );
  }

  Future<void> insertMedicine(Medicine med) async {
    var dbClient = await database;
    var medModel = med.toJson();
    var remModels = med.remsToJson();
    await dbClient.insert(tableMedicine, medModel);
    for (var remModel in remModels) {
      await dbClient.insert(tableMedicine, remModel, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  updateMedicine(Medicine med) async {
    var dbClient = await database;
    dbClient.update(tableMedicine, med.toJson(), where: '$colId = ?', whereArgs: [med.id]);
  }

  Future<Medicine> getMedicine(int id) async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query(tableMedicine, where: '$colId = ?', whereArgs: [id]);
    return maps.isNotEmpty ? Medicine.fromJson(maps.first) : Medicine(id: 'x'); //id x signifies failure
  }

  Future<List<Medicine>> getAllMedicines() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query(tableMedicine);
    return maps.map((e) {
      return Medicine.fromJson(e);
    }).toList();
  }

  Future<int> deleteMedicine (int id) async {
    var dbClient = await database;
    return await dbClient.delete(tableMedicine, where: '$colId = ?', whereArgs: [id]);
  }
}
import 'package:drugstore/database/models/Drug.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_manager.dart';

class DrugManager {
  static const tableName = 'drug';
  // create crud for Drug
  // use DatabaseHelper class to execute sql statements

  static final DrugManager instance = DrugManager._internal();

  DrugManager._internal();

  static Future<void> init() async {
    // create table
    Database? db = await DatabaseHelper.instance.database;
    if (db == null) return;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        image TEXT NOT NULL
      )
    ''');
  }

  Future<Drug?> add(Drug drug) async {
    // add drug to database
    int result = await DatabaseHelper.instance
        .insert(DrugManager.tableName, drug.toMap());

    if (result == 0) return null;

    return get(result);
  }

  Future<Drug?> update(Drug drug) async {
    // update drug in database
    int result = await DatabaseHelper.instance.update(
      DrugManager.tableName,
      drug.toMap(),
      'id = ?',
      whereArgs: [drug.id],
    );
    print("Edit result: $result");
    return get(result);
  }

  Future<void> delete(Drug drug) async {
    // delete drug from database
    DatabaseHelper.instance.delete(
      DrugManager.tableName,
      'id = ?',
      whereArgs: [drug.id],
    );

    DatabaseHelper.instance.close();
  }

  Future<void> deleteBy(int drugId) async {
    // delete drug from database
    // check that drug exists with id
    try {
      DatabaseHelper.instance.delete(
        DrugManager.tableName,
        'id = ?',
        whereArgs: [drugId],
      );
    } catch (e) {
      return;
    }
  }

  Future<List<Drug>> getAll() async {
    // get all drugs from database
    Database? db = await DatabaseHelper.instance.database;
    if (db == null) return [];
    List<Map<String, dynamic>> maps = await db.query(DrugManager.tableName);
    return maps.map((map) => Drug.fromMap(map)).toList();
  }

  Future<Drug?> get(int id) async {
    // get drug by id from database
    Database? db = await DatabaseHelper.instance.database;
    if (db == null) return null;
    List<Map<String, dynamic>> maps = await db.query(
      DrugManager.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Drug.fromMap(maps.first);
    }
    return null;
  }
}

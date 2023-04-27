import 'dart:typed_data';

import 'package:sqflite_common/sqlite_api.dart' show Database;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_manager.dart';

class MediaManager {
  static const tableName = 'images';

  static final MediaManager instance = MediaManager._internal();

  MediaManager._internal();

  static Future<void> init() async {
    // create table
    Database? db = await DatabaseHelper.instance.database;
    if (db == null) return;
    // write query to store image binary data with an id with keys id and image
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        key TEXT PRIMARY KEY ,
        image BLOB
      )
    ''');
  }

  Future<int> add(String key, Uint8List data) async {
    Database? db = await DatabaseHelper.instance.database;
    if (db == null) return 0;

    return await db.insert(tableName, {'key': key, 'image': data});
  }

  Future<int> update(String key, Uint8List data) async {
    Database? db = await DatabaseHelper.instance.database;
    if (db == null) return 0;

    return await db.update(tableName, {'key': key, 'image': data},
        where: 'key = ?', whereArgs: [key]);
  }

  Future<int> delete(String key) async {
    Database? db = await DatabaseHelper.instance.database;
    if (db == null) return 0;

    return await db.delete(tableName, where: 'key = ?', whereArgs: [key]);
  }

  Future<Uint8List?> get(String key) async {
    Database? db = await DatabaseHelper.instance.database;
    if (db == null) return null;

    List<Map<String, dynamic>> results =
        await db.query(tableName, where: 'key = ?', whereArgs: [key]);

    if (results.isEmpty) return null;
    
    return results.first['image'];
  }
} 
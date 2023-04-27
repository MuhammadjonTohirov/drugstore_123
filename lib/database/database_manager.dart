// ignore: file_names
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite_common/sqlite_api.dart';

class DatabaseHelper {
  static const dbName = 'myDatabase.db';
  static const dbVersion = 2;

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    _database ??= await _initDatabase();
    return _database;
  }

  // Open the database or create if doesn't exist
  _initDatabase() async {
    sqfliteFfiInit();
    return await databaseFactoryFfi.openDatabase("${dbName}_v$dbVersion");
  }

  // Create a table with tableName and columns specified by schema
  Future<void> createTable(
      String tableName, List<Map<String, dynamic>> schema) async {
    Database? db = await instance.database;
    if (db == null) return;
    String schemaString =
        schema.map((column) => '${column['name']} ${column['type']}').join(',');
    String sql = 'CREATE TABLE IF NOT EXISTS $tableName ($schemaString)';

    await db.execute(sql);
  }

  // Insert a new row into tableName
  Future<int> insert(String tableName, Map<String, dynamic> dataMap) async {
    Database? db = await instance.database;
    if (db == null) return 0;
    if (!db.isOpen) return 0;

    return await db.insert(tableName, dataMap);
  }

  // Update rows in tableName matching whereArgs with values in dataMap
  Future<int> update(
      String tableName, Map<String, dynamic> dataMap, String whereClause,
      {required List<dynamic> whereArgs}) async {
    Database? db = await instance.database;
    if (db == null) return 0;

    return await db.update(tableName, dataMap,
        where: whereClause, whereArgs: whereArgs);
  }

  // Delete rows in tableName matching whereArgs
  Future<int> delete(String tableName, String whereClause,
      {required List<dynamic> whereArgs}) async {
    Database? db = await instance.database;
    if (db == null) return 0;

    return await db.delete(tableName, where: whereClause, whereArgs: whereArgs);
  }

  // Query all rows in tableName as a list of maps
  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database? db = await instance.database;
    if (db == null) return [];

    return await db.query(tableName);
  }

  Future<void> close() async {
    Database? db = await instance.database;
    if (db == null) return;
    db.close();
  }

  // Compress the image and return its bytes as a base64-encoded string
  // Future<String> compressImage(File imageFile) async {
  //   List<int> bytes = await imageFile.readAsBytes();
  //   int quality = 60;
  //   while (bytes.length > 15000) {
  //     bytes = await FlutterImageCompress.compressWithList(
  //       bytes,
  //       minHeight: 400,
  //       minWidth: 400,
  //       quality: quality,
  //     );
  //     quality -= 10;
  //   }
  //   String compressedBytes = base64Encode(bytes);
  //   return compressedBytes;
  // }
}

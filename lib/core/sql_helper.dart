import 'package:path/path.dart' as sys_path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

abstract class SqlHelper {
  static sql.Database? _appDB;

  static Future<sql.Database> get _database async {
    if (_appDB == null) {
      // get the right path for storing app DB
      final dbPath = await sql.getDatabasesPath();
      // open database and return it
      _appDB = await sql.openDatabase(sys_path.join(dbPath, 'todo.db'),
          onCreate: (database, version) async {
        return await _onCreate(db: database);
      }, version: 1);
    }
    return _appDB!;
  }

  static Future<void> _onCreate({required sql.Database db}) async {
    return await _createTasksTable(db: db);
  }

  static Future<void> _createTasksTable({required sql.Database db}) async {
    await db.execute('''
    CREATE TABLE tasks(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    time TEXT NOT NULL,
    date TEXT NOT NULL,
    status TEXT NOT NULL
    )
    ''');
  }

  static Future<List<Map<String, dynamic>>> getData(
      {required String table}) async {
    // access the database
    final db = await _database;
    return await db.query(table);
  }

  static Future<int> insert(
      {required String table, required Map<String, dynamic> data}) async {
    // access the database
    final db = await _database;
    return await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<int> update({
    required String table,
    required Map<String, dynamic> data,
    required String columnValue,
    required String columnName,
  }) async {
    final db = await _database;

    return await db.update(
      table,
      data,
      where: '$columnName = ?',
      whereArgs: [columnValue],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> delete(
      {required String table,
      required String columnName,
      required String columnValue}) async {
    final db = await _database;
    return await db.delete(
      table,
      where: '$columnName = ?',
      whereArgs: [columnValue],
    );
  }
}

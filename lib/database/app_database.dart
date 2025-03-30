import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if(_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }
  
  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');
    
    return await openDatabase(path,
    onCreate: (db, version){
      return db.execute(
        'CREATE TABLE todos('
            'id INTEGER PRIMARY KEY,'
            'title TEXT NOT NULL,'
            'isDone INTEGER DEFAULT 0,'
            'dateTime TEXT,'
            'allDay INTEGER DEFAULT 0'
            ')'
      );
    }
    );
  }
}

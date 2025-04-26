import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static void _createTodoTable(Database db, int version) {
    db.execute('''CREATE TABLE todos(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        isDone INTEGER DEFAULT 0,
        dateTime TEXT,
        allDay INTEGER DEFAULT 0,
        categoryId INTEGER
        )''');
  }

  static void _createCategoryTable(Database db, int version) {
    db.execute('''CREATE TABLE categories(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        isDone INTEGER DEFAULT 0,
        isDefault INTEGER DEFAULT 0
        )''');
  }

  static void _updateTodoTable(Database db, int oldVersion, int newVersion) {
    if (oldVersion < 2) {
      db.execute('ALTER TABLE todos ADD COLUMN categoryId INTEGER');
    }
  }

  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');

    return await openDatabase(path, onCreate: (db, version) {
      _createTodoTable(db, version);
      _createCategoryTable(db, version);
    }, onUpgrade: (db, oldVersion, newVersion) {
      _updateTodoTable(db, oldVersion, newVersion);
      _createCategoryTable(db, newVersion);
    }, version: 2);
  }
}

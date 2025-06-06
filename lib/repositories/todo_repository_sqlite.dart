import 'package:sqflite/sqflite.dart';
import 'package:todo_flutter/database/app_database.dart';
import 'package:todo_flutter/models/todo_item.dart';
import 'package:todo_flutter/repositories/todo_repository.dart';

class TodoRepositorySqlite implements TodoRepository {
  @override
  Future<void> addTodo(TodoItem item) async {
    final db = await AppDatabase.getDatabase();

    int id = await db.insert('todos', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    item.id = id;
  }

  @override
  Future<void> deleteTodo(int id) async {
    final db = await AppDatabase.getDatabase();

    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<TodoItem>> getTodos() async {
    final db = await AppDatabase.getDatabase();

    final List<Map<String, Object?>> todoMaps = await db.query('todos');

    return [for (final item in todoMaps) TodoItem.fromMap(item)];
  }

  @override
  Future<void> updateTodo(TodoItem item) async {
    final db = await AppDatabase.getDatabase();

    await db
        .update('todos', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }
}

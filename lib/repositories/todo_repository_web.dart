import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/models/todo_item.dart';
import 'package:todo_flutter/repositories/todo_repository.dart';

class TodoRepositoryWeb implements TodoRepository {
  final String key = 'todo_items';

  @override
  Future<void> addTodo(TodoItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodos();

    item.id = DateTime.now().millisecondsSinceEpoch;
    todos.add(item);

    final json = jsonEncode(todos.map((e) => e.toMap()).toList());
    await prefs.setString(key, json);
  }

  @override
  Future<void> deleteTodo(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodos();

    todos.removeWhere((e) => e.id == id);
    final json = jsonEncode(todos.map((e) => e.toMap()).toList());
    await prefs.setString(key, json);
  }

  @override
  Future<List<TodoItem>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => TodoItem.fromMap(e)).toList();
  }

  @override
  Future<void> updateTodo(TodoItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodos();

    final index = todos.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      todos[index] = item;
      final json = jsonEncode(todos.map((e) => e.toMap()).toList());
      await prefs.setString(key, json);
    }
  }
}

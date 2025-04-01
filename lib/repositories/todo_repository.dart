import 'package:todo_flutter/models/todo_item.dart';

abstract interface class TodoRepository{
  Future<void> addTodo(TodoItem item);
  Future<List<TodoItem>> getTodos();
  Future<void> deleteTodo(int id);
  Future<void> updateTodo(TodoItem item);
}
import 'package:flutter/cupertino.dart';
import 'package:todo_flutter/todo_item.dart';

class TodoProvider extends ChangeNotifier {
  final List<TodoItem> _items = [];

  TodoProvider() {
    _addInitialItems();
  }

  List<TodoItem> getTodoItems({bool done = false}) {
    return _items.where((item) => item.isDone == done).toList();
  }

  int getTodoItemCount({bool done = false}) {
    return getTodoItems(done: done).length;
  }

  void _addInitialItems() {
    addItem(TodoItem(title: 'Item 1'));
    addItem(TodoItem(title: 'Item 2'));
    addItem(TodoItem(title: 'Item 3'));
  }

  int get itemCount => _items.length;

  List<TodoItem> get items => List.unmodifiable(_items);

  void addItem(TodoItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(TodoItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void toggleItem(TodoItem item) {
    item.toggleDone();
    notifyListeners();
  }
}
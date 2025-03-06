import 'package:flutter/cupertino.dart';
import 'package:todo_flutter/todo_item.dart';

class TodoProvider extends ChangeNotifier {
  final List<TodoItem> _items = [];
  final List<TodoItem> _doneItems = [];
  final List<TodoItem> _undoneItems = [];

  TodoProvider() {
    _addInitialItems();
  }

  void _addInitialItems() {
    addItem(TodoItem(title: 'Item 1'));
    addItem(TodoItem(title: 'Item 2'));
    addItem(TodoItem(title: 'Item 3'));
  }

  int get itemCount => _items.length;
  int get doneItemCount => _doneItems.length;
  int get undoneItemCount => _undoneItems.length;

  List<TodoItem> get items => List.unmodifiable(_items);
  List<TodoItem> get doneItems => List.unmodifiable(_doneItems);
  List<TodoItem> get undoneItems => List.unmodifiable(_undoneItems);

  void _updateLists() {
    _doneItems.clear();
    _undoneItems.clear();
    for (var item in _items) {
      if (item.isDone) {
        _doneItems.add(item);
      } else {
        _undoneItems.add(item);
      }
    }
  }

  int _getInsertIndex(List<TodoItem> list, TodoItem item) {
    for (var i = 0; i < list.length; i++) {
      if (list[i].compareTo(item) > 0) {
        return i;
      }
    }
    return list.length;
  }

  void addItem(TodoItem item) {
    _items.add(item);
    final int idx = _getInsertIndex(_items, item);
    if(item.isDone){
      _doneItems.insert(idx, item);
    }else{
      _undoneItems.insert(idx, item);
    }
    notifyListeners();
  }

  void removeItem(TodoItem item) {
    final int idx = _getInsertIndex(_items, item);
    if(item.isDone){
      _doneItems.remove(item);
    }else{
      _undoneItems.remove(item);
    }
    notifyListeners();
  }

  void toggleItem(TodoItem item) {
    removeItem(item);
    item.toggleDone();
    addItem(item);
    notifyListeners();
  }
}
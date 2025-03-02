import 'package:flutter/cupertino.dart';
import 'package:todo_flutter/todo_item.dart';

class TodoProvider extends ChangeNotifier{
  final List<TodoItem> _items = [];

  TodoProvider(){
    _items.add(TodoItem(title: 'Item 1'));
    _items.add(TodoItem(title: 'Item 2'));
    _items.add(TodoItem(title: 'Item 3'));
  }

  int get itemCount => _items.length;

  List<TodoItem> get items => _items;

  void addItem(TodoItem item){
    _items.add(item);
    notifyListeners();
  }

  void removeItem(TodoItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void toggleItem(TodoItem item){
    item.toggleDone();
    notifyListeners();
  }
}
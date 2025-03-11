import 'package:flutter/cupertino.dart';
import 'package:todo_flutter/category.dart';
import 'package:todo_flutter/todo_item.dart';

class TodoProvider extends ChangeNotifier {
  final List<Category> _categories = [];
  final List<TodoItem> _items = [];

  TodoProvider() {
    _addInitialItems();
    _addDefaultCategories();
  }

  void _addDefaultCategories() {
    _categories.add(Category(name: 'All', isDone: null));
    _categories.add(Category(name: 'Done', isDone: true));
    _categories.add(Category(name: 'Not Done', isDone: false));
  }

  List<TodoItem> getTodoItems({Category category = const Category()}) {
    if (category.isDone == null){
      return _items;
    }
      return _items.where((item) => item.isDone == category.isDone).toList();
  }

  int getTodoItemCount({Category category = const Category()}) {
    return getTodoItems(category: category).length;
  }

  void _addInitialItems() {
    addItem(TodoItem(title: 'Item 1'));
    addItem(TodoItem(title: 'Item 2'));
    addItem(TodoItem(title: 'Item 3'));
  }

  int get itemCount => _items.length;
  List<TodoItem> get items => List.unmodifiable(_items);

  int get categoryCount => _categories.length;
  List<Category> get categories => List.unmodifiable(_categories);

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
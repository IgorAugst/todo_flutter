import 'package:flutter/cupertino.dart';
import 'package:todo_flutter/models/category.dart';
import 'package:todo_flutter/models/todo_item.dart';
import 'package:todo_flutter/repositories/todo_repository.dart';
import 'package:todo_flutter/repositories/todo_repository_sqlite.dart';

class TodoProvider extends ChangeNotifier {
  final List<Category> _categories = [];
  List<TodoItem> _items = [];
  final TodoRepository todoRepository = TodoRepositorySqlite();

  TodoProvider() {
    _addDefaultCategories();
    loadItems();
  }

  void _addDefaultCategories() {
    _categories.add(Category(name: 'All', isDone: null));
    _categories.add(Category(name: 'Done', isDone: true));
    _categories.add(Category(name: 'Not Done', isDone: false));
  }

  void _sortItems() {
    _items.sort();
  }

  List<TodoItem> getTodoItems({Category category = const Category()}) {
    if (category.isDone == null) {
      return _items;
    }
    return _items.where((item) => item.isDone == category.isDone).toList();
  }

  int getTodoItemCount({Category category = const Category()}) {
    return getTodoItems(category: category).length;
  }

  Future<void> _addInitialItems() async {
    await addItem(TodoItem(title: 'Item 1'));
    await addItem(TodoItem(title: 'Item 2'));
    await addItem(TodoItem(title: 'Item 3'));
  }

  int get itemCount => _items.length;
  List<TodoItem> get items => List.unmodifiable(_items);

  int get categoryCount => _categories.length;
  List<Category> get categories => List.unmodifiable(_categories);

  Future<List<TodoItem>> loadItems() async {
    _items = await todoRepository.getTodos();
    _items.sort();
    notifyListeners();

    return _items;
  }

  Future<void> addItem(TodoItem item) async {
    await todoRepository.addTodo(item);
    _items.add(item);
    _sortItems();
    notifyListeners();
  }

  void removeItem(TodoItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void toggleItem(TodoItem item) {
    item.toggleDone();
    _sortItems();
    notifyListeners();
  }

  Future<void> updateItem(TodoItem updatedItem) async {
    await todoRepository.updateTodo(updatedItem);
    _sortItems();
    notifyListeners();
  }
}

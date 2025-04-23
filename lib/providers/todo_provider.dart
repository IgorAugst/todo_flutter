import 'package:flutter/cupertino.dart';
import 'package:todo_flutter/models/category.dart';
import 'package:todo_flutter/models/todo_item.dart';
import 'package:todo_flutter/repositories/notification_repository.dart';
import 'package:todo_flutter/repositories/todo_repository.dart';
import 'package:todo_flutter/repositories/todo_repository_sqlite.dart';

class TodoProvider extends ChangeNotifier {
  final List<Category> _categories = [];
  List<TodoItem> _items = [];
  final TodoRepository todoRepository = TodoRepositorySqlite();

  int get categoryCount => _categories.length;
  List<Category> get categories => List.unmodifiable(_categories);

  TodoProvider() {
    _addDefaultCategories();
    loadItems();
  }

  int getCategoriesCount({bool? isDone, bool? isDefault}) {
    return getCategories(isDone: isDone, isDefault: isDefault).length;
  }

  List<Category> getCategories({bool? isDone, bool? isDefault}) {
    return _categories
        .where((category) =>
            (isDone == null || category.isDone == isDone) &&
            (isDefault == null || category.isDefault == isDefault))
        .toList();
  }

  void _addDefaultCategories() {
    _categories.add(Category(name: 'Todos', isDone: null, isDefault: true));
    _categories.add(Category(name: 'Completos', isDone: true, isDefault: true));
    _categories
        .add(Category(name: 'Incompletos', isDone: false, isDefault: true));
    _categories
        .add(Category(name: 'Nova categoria', isDone: null, isDefault: false));
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

  int get itemCount => _items.length;
  List<TodoItem> get items => List.unmodifiable(_items);

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

    scheduleNotification(item);
  }

  Future<void> removeItem(TodoItem item) async {
    await todoRepository.deleteTodo(item.id!);
    _items.remove(item);
    notifyListeners();
    await NotificationRepository.cancelNotification(item.id!);
  }

  Future<void> toggleItem(TodoItem item) async {
    item.toggleDone();
    await todoRepository.updateTodo(item);
    _sortItems();
    notifyListeners();

    if (item.isDone) {
      NotificationRepository.cancelNotification(item.id!);
    } else {
      scheduleNotification(item);
    }
  }

  Future<void> updateItem(TodoItem updatedItem) async {
    await todoRepository.updateTodo(updatedItem);
    _sortItems();
    notifyListeners();

    scheduleNotification(updatedItem);
  }

  void insertCategory(String title) {
    _categories.add(Category(name: title, isDone: null, isDefault: false));
    notifyListeners();
  }

  void deleteCategory(Category category) {
    _categories.remove(category);
    notifyListeners();
  }

  void scheduleNotification(TodoItem item) {
    if (item.dateTime != null &&
        item.dateTime!.compareTo(DateTime.now()) == 1) {
      NotificationRepository.scheduleNotification(
          id: item.id ?? 0,
          title: item.title,
          body: item.dateTimeText(),
          datetime: item.dateTime!);
    }
  }
}

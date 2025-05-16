import 'package:flutter/cupertino.dart';
import 'package:todo_flutter/models/category.dart';
import 'package:todo_flutter/models/todo_item.dart';
import 'package:todo_flutter/repositories/notification_repository.dart';
import 'package:todo_flutter/repositories/todo_repository.dart';

class TodoProvider extends ChangeNotifier {
  List<TodoItem> _items = [];
  final TodoRepository todoRepository;
  final NotificationRepository notificationRepository;

  TodoProvider(
      {required this.todoRepository, required this.notificationRepository}) {
    loadItems();
  }

  void _sortItems() {
    _items.sort();
  }

  List<TodoItem> getTodoItems({Category? category}) {
    if (category == null) {
      return _items;
    }

    if (category.isDefault) {
      if (category.isDone != null) {
        return _items.where((item) => item.isDone == category.isDone).toList();
      } else {
        return _items;
      }
    } else {
      return _items.where((item) => item.categoryId == category.id).toList();
    }
  }

  int getTodoItemCount({Category? category}) {
    if (category == null) {
      return _items.length;
    }

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
    await notificationRepository.cancelNotification(item.id!);
  }

  Future<void> toggleItem(TodoItem item) async {
    item.toggleDone();
    await todoRepository.updateTodo(item);
    _sortItems();
    notifyListeners();

    if (item.isDone) {
      notificationRepository.cancelNotification(item.id!);
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

  void scheduleNotification(TodoItem item) {
    if (item.dateTime != null &&
        item.dateTime!.compareTo(DateTime.now()) == 1) {
      notificationRepository.scheduleNotification(
          id: item.id ?? 0,
          title: item.title,
          body: item.dateTimeText(),
          datetime: item.dateTime!);
    }
  }
}

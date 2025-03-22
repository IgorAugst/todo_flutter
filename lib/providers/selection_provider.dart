import 'package:flutter/widgets.dart';
import 'package:todo_flutter/models/todo_item.dart';

class SelectionProvider extends ChangeNotifier{
  final List<TodoItem> _selectedItems = [];

  List<TodoItem> get selectedItems => List.unmodifiable(_selectedItems);

  void toggleSelection(TodoItem todoItem){
    if(_selectedItems.contains(todoItem)){
      _selectedItems.remove(todoItem);
    }else{
      _selectedItems.add(todoItem);
    }
  }

  bool checkSelection(TodoItem todoItem) {
    return _selectedItems.contains(todoItem);
  }

  void clearSelection(){
    _selectedItems.clear();
  }
}
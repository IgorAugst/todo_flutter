import 'package:flutter/material.dart';
import 'package:todo_flutter/models/category.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider() {
    _addDefaultCategories();
  }

  final List<Category> _categories = [];

  int get categoryCount => _categories.length;
  List<Category> get categories => List.unmodifiable(_categories);

  List<Category> getCategories({bool? isDone, bool? isDefault}) {
    return _categories
        .where((category) =>
            (isDone == null || category.isDone == isDone) &&
            (isDefault == null || category.isDefault == isDefault))
        .toList();
  }

  int getCategoriesCount({bool? isDone, bool? isDefault}) {
    return getCategories(isDone: isDone, isDefault: isDefault).length;
  }

  void _addDefaultCategories() {
    _categories.add(Category.defaultCategory());
    _categories.add(Category(name: 'Completos', isDone: true, isDefault: true));
    _categories
        .add(Category(name: 'Incompletos', isDone: false, isDefault: true));
    _categories
        .add(Category(name: 'Nova categoria', isDone: null, isDefault: false));
  }

  void insertCategory(String title) {
    _categories.add(Category(name: title, isDone: null, isDefault: false));
    notifyListeners();
  }

  void deleteCategory(Category category) {
    _categories.remove(category);
    notifyListeners();
  }

  void updateCategory(Category category, String newName) {
    int index = _categories.indexOf(category);
    if (index != -1) {
      _categories[index] = Category();
      notifyListeners();
    }
  }
}

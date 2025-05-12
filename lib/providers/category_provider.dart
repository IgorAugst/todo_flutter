import 'package:flutter/material.dart';
import 'package:todo_flutter/models/category.dart';
import 'package:todo_flutter/repositories/category_repository.dart';
import 'package:todo_flutter/repositories/category_repository_sqlite.dart';

class CategoryProvider extends ChangeNotifier {
  final List<Category> _categories = [];

  final CategoryRepository _categoryRepository = CategoryRepositorySQLite();

  CategoryProvider() {
    _addDefaultCategories();
    loadCategories();
  }

  int get categoryCount => _categories.length;
  List<Category> get categories => List.unmodifiable(_categories);

  List<Category> getCategories({bool? isDone, bool? isDefault}) {
    return _categories
        .where((category) =>
            (isDone == null || category.isDone == isDone) &&
            (isDefault == null || category.isDefault == isDefault))
        .toList();
  }

  Category getCategoryById(int id) {
    return _categories.firstWhere((category) => category.id == id);
  }

  Future<List<Category>> loadCategories() async {
    _categories.addAll(await _categoryRepository.getCategories());
    notifyListeners();
    return _categories;
  }

  int getCategoriesCount({bool? isDone, bool? isDefault}) {
    return getCategories(isDone: isDone, isDefault: isDefault).length;
  }

  void _addDefaultCategories() {
    _categories.add(Category.defaultCategory());
    _categories.add(Category(name: 'Completos', isDone: true, isDefault: true));
    _categories
        .add(Category(name: 'Incompletos', isDone: false, isDefault: true));
  }

  void insertCategory(String title) async {
    var newCategory = Category(
      name: title,
      isDone: null,
      isDefault: false,
    );

    await _categoryRepository.addCategory(newCategory);
    _categories.add(newCategory);
    notifyListeners();
  }

  void deleteCategory(Category category) async {
    await _categoryRepository.deleteCategory(category.id!);

    _categories.remove(category);
    notifyListeners();
  }

  void updateCategory(Category category, String newName) async {
    category.name = newName;
    await _categoryRepository.updateCategory(category);
  }
}

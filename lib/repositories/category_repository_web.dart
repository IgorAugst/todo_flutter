// category_repository_web.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/models/category.dart';
import 'package:todo_flutter/repositories/category_repository.dart';

class CategoryRepositoryWeb implements CategoryRepository {
  final String _key = 'categories';

  Future<void> _initializeCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      final defaultCategories = [
        Category(id: 1, name: 'Importantes', isDefault: false),
      ];
      await _saveCategories(defaultCategories);
    }
  }

  Future<List<Category>> _getAllCategories() async {
    await _initializeCategories();

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Category.fromMap(e)).toList();
  }

  Future<void> _saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(categories.map((e) => e.toMap()).toList());
    await prefs.setString(_key, encoded);
  }

  @override
  Future<void> addCategory(Category category) async {
    final categories = await _getAllCategories();

    category.id = DateTime.now().millisecondsSinceEpoch;
    categories.add(category);

    await _saveCategories(categories);
  }

  @override
  Future<void> deleteCategory(int id) async {
    final categories = await _getAllCategories();
    categories.removeWhere((c) => c.id == id);

    await _saveCategories(categories);
  }

  @override
  Future<List<Category>> getCategories() async {
    return _getAllCategories();
  }

  @override
  Future<void> updateCategory(Category category) async {
    final categories = await _getAllCategories();

    final index = categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      categories[index] = category;
      await _saveCategories(categories);
    }
  }
}

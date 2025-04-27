import 'package:todo_flutter/models/category.dart';

abstract interface class CategoryRepository {
  Future<void> addCategory(Category category);
  Future<List<Category>> getCategories();
  Future<void> deleteCategory(int id);
  Future<void> updateCategory(Category category);
}

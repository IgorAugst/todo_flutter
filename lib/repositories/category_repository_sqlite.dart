import 'package:sqflite/sqflite.dart';
import 'package:todo_flutter/models/category.dart';
import 'package:todo_flutter/repositories/category_repository.dart';

import '../database/app_database.dart';

class CategoryRepositorySQLite implements CategoryRepository {
  @override
  Future<void> addCategory(Category category) async {
    final db = await AppDatabase.getDatabase();

    int id = await db.insert('categories', category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    category.id = id;
  }

  @override
  Future<void> deleteCategory(int id) async {
    final db = await AppDatabase.getDatabase();

    await db.execute(
        'UPDATE todos SET categoryId = NULL WHERE categoryId = ?', [id]);

    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Category>> getCategories() async {
    final db = await AppDatabase.getDatabase();

    final List<Map<String, Object?>> categoryMaps =
        await db.query('categories');

    return [for (final item in categoryMaps) Category.fromMap(item)];
  }

  @override
  Future<void> updateCategory(Category category) async {
    final db = await AppDatabase.getDatabase();

    await db.update('categories', category.toMap(),
        where: 'id = ?', whereArgs: [category.id]);
  }
}

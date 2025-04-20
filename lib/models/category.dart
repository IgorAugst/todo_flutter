class Category {
  final String? id;
  final String name;
  final bool? isDone;
  final bool isDefault;

  const Category(
      {this.id, this.name = "Todos", this.isDone, this.isDefault = false});
}

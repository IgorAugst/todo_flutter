class Category {
  final String? id;
  String name;
  final bool? isDone;
  final bool isDefault;

  Category({this.id, this.name = "Todos", this.isDone, this.isDefault = false});
}

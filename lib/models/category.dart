class Category {
  int? id;
  String name;
  bool? isDone;
  bool isDefault;

  Category({this.id, this.name = "Todos", this.isDone, this.isDefault = false});

  Category.defaultCategory()
      : id = null,
        name = "Todos",
        isDone = null,
        isDefault = true;

  factory Category.fromMap(Map<String, Object?> map) {
    return Category(
      id: int.tryParse(map['id'].toString()),
      name: map['name'].toString(),
      isDone:
          map['isDone'] == null ? null : (map['isDone'] == 1 ? true : false),
      isDefault: map['isDefault'] == 1 ? true : false,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'isDone': isDone == null ? null : (isDone == true ? 1 : 0),
      'isDefault': isDefault == true ? 1 : 0,
    };
  }
}

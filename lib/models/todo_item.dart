import 'package:intl/intl.dart';

class TodoItem implements Comparable {
  int? id;
  String title;
  bool isDone = false;
  DateTime? dateTime;
  bool allDay = false;
  int? categoryId;

  TodoItem(
      {this.id,
      required this.title,
      this.dateTime,
      this.isDone = false,
      this.allDay = false,
      this.categoryId});

  factory TodoItem.fromMap(Map<String, Object?> map) {
    return TodoItem(
        id: int.tryParse(map['id'].toString()),
        title: map['title'].toString(),
        isDone: map['isDone'] == 1 ? true : false,
        dateTime: DateTime.tryParse(map['dateTime'].toString()),
        allDay: map['allDay'] == 1 ? true : false,
        categoryId: int.tryParse(map['categoryId'].toString()));
  }

  void toggleDone() {
    isDone = !isDone;
  }

  TodoItem updateFrom(TodoItem item) {
    title = item.title;
    isDone = item.isDone;
    dateTime = item.dateTime;
    allDay = item.allDay;
    categoryId = item.categoryId;

    return this;
  }

  String dateTimeText() {
    if (dateTime == null) {
      return 'Horário';
    }

    if (allDay) {
      return DateFormat('dd/MM/yyyy').format(dateTime!);
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime!);
    }
  }

  int _compareTime(DateTime? a, DateTime? b) {
    if (a != null && b != null) {
      return a.compareTo(b);
    } else if (a == null && b != null) {
      return 1;
    } else if (a != null && b == null) {
      return -1;
    } else {
      return 0;
    }
  }

  int _compareText(String a, String b) {
    return a.compareTo(b);
  }

  int _compareBool(bool a, bool b) {
    if (a && !b) {
      return 1;
    } else if (!a && b) {
      return -1;
    } else {
      return 0;
    }
  }

  @override
  int compareTo(other) {
    var comparator = [
      () => _compareBool(isDone, other.isDone),
      () => _compareTime(dateTime, other.dateTime),
      () => _compareText(title, other.title)
    ];

    return _compareMultiple(comparator);
  }

  int _compareMultiple(List<int Function()> comparisons) {
    for (var compare in comparisons) {
      final result = compare();
      if (result != 0) return result;
    }
    return 0;
  }

  Map<String, Object?> toMap() {
    String? dateTimeISO;

    if (dateTime != null) {
      dateTimeISO = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime!);
    }

    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
      'dateTime': dateTimeISO,
      'allDay': allDay ? 1 : 0,
      'categoryId': categoryId,
    };
  }

  @override
  String toString() {
    return 'TodoItem{id: $id, title: $title, isDone: $isDone, dateTime: $dateTime, allDay: $allDay, categoryId: $categoryId}';
  }
}

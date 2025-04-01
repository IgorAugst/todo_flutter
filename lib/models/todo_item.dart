import 'package:intl/intl.dart';

class TodoItem implements Comparable {
  int? id;
  String title;
  bool isDone = false;
  DateTime? dateTime;
  bool allDay = false;

  TodoItem(
      {this.id,
      required this.title,
      this.dateTime,
      this.isDone = false,
      this.allDay = false});

  factory TodoItem.fromMap(Map<String, Object?> map) {
    return TodoItem(
        id: int.tryParse(map['id'].toString()),
        title: map['title'].toString(),
        isDone: map['isDone'] == 1 ? true : false,
        dateTime: DateTime.tryParse(map['dateTime'].toString()),
        allDay: map['allDay'] == 1 ? true : false);
  }

  void toggleDone() {
    isDone = !isDone;
  }

  TodoItem updateFrom(TodoItem item) {
    title = item.title;
    isDone = item.isDone;
    dateTime = item.dateTime;
    allDay = item.allDay;

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

  @override
  int compareTo(other) {
    if (isDone && !other.isDone) {
      return 1;
    } else if (!isDone && other.isDone) {
      return -1;
    } else {
      return title
          .toLowerCase()
          .compareTo(other.title.toString().toLowerCase());
    }
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
    };
  }

  @override
  String toString() {
    return 'TodoItem{id: $id, title: $title, isDone: $isDone, dateTime: $dateTime, allDay: $allDay}';
  }
}

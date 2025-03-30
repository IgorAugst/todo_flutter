import 'package:intl/intl.dart';

class TodoItem implements Comparable{
  String title;
  bool isDone = false;
  DateTime? dateTime;
  bool allDay = false;

  TodoItem({required this.title, this.dateTime, this.allDay = false});

  void toggleDone(){
    isDone = !isDone;
  }

  void updateFrom(TodoItem item){
    title = item.title;
    isDone = item.isDone;
    dateTime = item.dateTime;
    allDay = item.allDay;
  }

  String dateTimeText(){
    if(dateTime == null){
      return 'Horário';
    }

    if(allDay){
      return DateFormat('dd/MM/yyyy').format(dateTime!);
    }else{
      return DateFormat('dd/MM/yyyy hh:mm').format(dateTime!);
    }
  }

  @override
  int compareTo(other) {
    if(isDone && !other.isDone){
      return 1;
    }else if(!isDone && other.isDone){
      return -1;
    }else{
      return title.toLowerCase().compareTo(other.title.toString().toLowerCase());
    }
  }

  Map<String, Object?> toMap(){
    String? dateTimeISO;

    if (dateTime != null) {
      dateTimeISO = DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime!);
    }

    return {'title': title, 'isDone': isDone, 'dateTime': dateTimeISO, 'allDay': allDay};
  }
}
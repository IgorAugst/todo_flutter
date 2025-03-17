class TodoItem implements Comparable{
  String title;
  bool isDone = false;

  TodoItem({required this.title});

  void toggleDone(){
    isDone = !isDone;
  }

  void updateFrom(TodoItem item){
    title = item.title;
    isDone = item.isDone;
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
}
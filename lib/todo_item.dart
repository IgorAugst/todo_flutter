class TodoItem implements Comparable{
  String title;
  bool isDone = false;

  TodoItem({required this.title});

  void toggleDone(){
    isDone = !isDone;
  }

  @override
  int compareTo(other) {
    if(isDone && !other.isDone){
      return 1;
    }else if(!isDone && other.isDone){
      return -1;
    }else{
      return title.compareTo(other.title);
    }
  }
}
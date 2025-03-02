class TodoItem{
  String title;
  bool isDone = false;

  TodoItem({required this.title});

  void toggleDone(){
    isDone = !isDone;
  }
}
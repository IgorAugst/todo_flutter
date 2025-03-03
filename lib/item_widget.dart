import 'package:flutter/material.dart';
import 'package:todo_flutter/todo_item.dart';
import 'package:todo_flutter/todo_provider.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatelessWidget {
  final int index;
  final bool isDone;

  const ItemWidget({super.key, required this.index, this.isDone = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(builder: (context, todoProvider, child) {
      late final TodoItem item;

      if(isDone){
        item = todoProvider.doneItems[index];
      }else{
        item = todoProvider.undoneItems[index];
      }

      return InkWell(
        onTap: () {
          todoProvider.toggleItem(item);
        },
        child: Row(
          children: [
            Checkbox(
                value: item.isDone,
                onChanged: (bool? value) {
                  todoProvider.toggleItem(item);
                }),
            RichText(
              text: TextSpan(
                text: item.title,
                style: TextStyle(
                  decoration: item.isDone ? TextDecoration.lineThrough : null,
                  color: Colors.black
                ),
              )
            )
          ],
        ),
      );
    });
  }
}

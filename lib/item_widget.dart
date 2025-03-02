import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/todo_provider.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatelessWidget {
  final int index;

  const ItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(builder: (context, todoProvider, child) {
      final item = todoProvider.items[index];
      return GestureDetector(
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

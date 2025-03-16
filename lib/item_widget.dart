import 'package:flutter/material.dart';
import 'package:todo_flutter/todo_item.dart';

class ItemWidget extends StatelessWidget {
  final TodoItem item;
  final Function(TodoItem) onToggle;

  const ItemWidget({super.key, required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onToggle(item);
      },
      child: Row(
        children: [
          Checkbox(
              value: item.isDone,
              onChanged: (bool? value) {
                onToggle(item);
              }),
          RichText(
              text: TextSpan(
            text: item.title,
            style: TextStyle(
                decoration: item.isDone ? TextDecoration.lineThrough : null,
                color: Colors.black),
          ))
        ],
      ),
    );
  }
}

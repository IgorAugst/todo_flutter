import 'package:flutter/material.dart';
import 'package:todo_flutter/todo_item.dart';

class ItemWidget extends StatelessWidget {
  final TodoItem item;
  final Function(TodoItem) onToggle;
  final Function(TodoItem)? onTap;

  const ItemWidget({super.key, required this.item, required this.onToggle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(item);
        }
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

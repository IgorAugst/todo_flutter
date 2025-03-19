import 'package:flutter/material.dart';
import 'package:todo_flutter/todo_item.dart';

class ItemWidget extends StatefulWidget {
  final TodoItem item;
  final Function(TodoItem) onToggle;
  final Function(TodoItem)? onTap;

  const ItemWidget({super.key, required this.item, required this.onToggle, this.onTap});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: selected ? Colors.red : Colors.blue,
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(widget.item);
        }
      },
      onLongPress: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Row(
        children: [
          Checkbox(
              value: widget.item.isDone,
              onChanged: (bool? value) {
                widget.onToggle(widget.item);
              }),
          RichText(
              text: TextSpan(
            text: widget.item.title,
            style: TextStyle(
                decoration: widget.item.isDone ? TextDecoration.lineThrough : null,
                color: Colors.black),
          ))
        ],
      ),
    );
  }
}

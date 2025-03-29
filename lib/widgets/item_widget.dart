import 'package:flutter/material.dart';
import 'package:todo_flutter/models/todo_item.dart';

class ItemWidget extends StatefulWidget {
  final TodoItem item;
  final Function(TodoItem) onToggle;
  final Function(TodoItem)? onTap;
  final Function(TodoItem)? onLongPress;
  final bool showCheckbox;

  const ItemWidget(
      {super.key,
      required this.item,
      required this.onToggle,
      this.onTap,
      this.onLongPress,
      this.showCheckbox = true});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(widget.item);
        }
      },
      onLongPress: () {
        if (widget.onLongPress != null) {
          widget.onLongPress!(widget.item);
        }
      },
      child: Row(
        children: [
          AnimatedOpacity(
            opacity: widget.showCheckbox ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: Checkbox(
                value: widget.item.isDone,
                onChanged: widget.showCheckbox
                    ? (bool? value) {
                        widget.onToggle(widget.item);
                      }
                    : null),
          ),
          RichText(
              text: TextSpan(
            text: widget.item.title,
            style: TextStyle(
              decoration:
                  widget.item.isDone ? TextDecoration.lineThrough : null,
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: MediaQuery.textScalerOf(context).scale(18)
            ),
          ))
        ],
      ),
    );
  }
}

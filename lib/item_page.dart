import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/todo_item.dart';
import 'package:todo_flutter/todo_provider.dart';

class ItemPage extends StatelessWidget {
  final String title;
  final TodoItem? item;

  const ItemPage({super.key, required this.title, this.item});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController(text: item?.title);

    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(child: Column(
              children: [
                TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Título',
                  ),
                  onSubmitted: (value) {
                    todoProvider.addItem(TodoItem(title: value));
                    Navigator.pop(context);
                  },
                )
              ],
            )),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (item != null){
                todoProvider.updateItem(item!, TodoItem(title: _controller.text));
              } else {
                todoProvider.addItem(TodoItem(title: _controller.text));
              }
              Navigator.pop(context);
            },
            tooltip: "Salvar",
            child: Icon(Icons.check,),
          ),
        );
      }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/todo_item.dart';
import 'package:todo_flutter/todo_provider.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Adicionar"),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(child: Column(
              children: [
                TextField(
                  controller: _controller,
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
              todoProvider.addItem(TodoItem(title: _controller.text));
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

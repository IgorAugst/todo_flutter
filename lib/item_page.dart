import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/todo_item.dart';
import 'package:todo_flutter/todo_provider.dart';

class ItemPage extends StatelessWidget {
  final String title;
  final TodoItem? item;

  const ItemPage({super.key, required this.title, this.item});

  void _saveItem(BuildContext context, TodoItem newItem) {
    var todoProvider = Provider.of<TodoProvider>(context, listen: false);

    if (item != null) {
      todoProvider.updateItem(item!, newItem);
    } else {
      todoProvider.addItem(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller =
        TextEditingController(text: item?.title);
    final _formItemPageKey = GlobalKey<FormState>();

    return Consumer<TodoProvider>(builder: (context, todoProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: _formItemPageKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Título',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título';
                      }

                      return null;
                    },
                    onFieldSubmitted: (value) {
                      if (_formItemPageKey.currentState!.validate()) {
                        _saveItem(context, TodoItem(title: _controller.text));
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formItemPageKey.currentState!.validate()) {
              _saveItem(context, TodoItem(title: _controller.text));
              Navigator.pop(context);
            }
          },
          tooltip: "Salvar",
          child: Icon(
            Icons.check,
          ),
        ),
      );
    });
  }
}

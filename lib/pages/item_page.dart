import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/todo_item.dart';
import 'package:todo_flutter/providers/todo_provider.dart';
import 'package:intl/intl.dart';

class ItemPage extends StatefulWidget {
  final String title;
  final TodoItem? item;

  const ItemPage({super.key, required this.title, this.item});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late TextEditingController _controller;
  final GlobalKey<FormState> _formItemPageKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.item?.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveItem(BuildContext context, TodoItem newItem) {
    var todoProvider = Provider.of<TodoProvider>(context, listen: false);

    if (widget.item != null) {
      todoProvider.updateItem(widget.item!, newItem);
    } else {
      todoProvider.addItem(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateText;

    if(selectedDate == null){
      dateText = 'Data';
    }else{
      dateText = DateFormat('dd/MM/yyyy').format(selectedDate!);
    }

    return Consumer<TodoProvider>(builder: (context, todoProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            var pickedDate = await showDatePicker(
                                context: context,
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030));

                            setState(() {
                              selectedDate = pickedDate;
                            });
                          },
                          child: Text(dateText)),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(onPressed: () {}, child: Text('hora'))
                    ],
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

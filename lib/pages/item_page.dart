import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/todo_item.dart';
import 'package:todo_flutter/providers/category_provider.dart';
import 'package:todo_flutter/providers/todo_provider.dart';

class ItemPage extends StatefulWidget {
  final String title;
  final TodoItem? item;
  final Function(TodoItem) onSubmit;

  const ItemPage(
      {super.key, required this.title, required this.onSubmit, this.item});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late TextEditingController _controller;
  late TextEditingController _dropdownController;
  final GlobalKey<FormState> _formItemPageKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  CategoryProvider? _categoryProvider;

  @override
  void initState() {
    super.initState();
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    _controller = TextEditingController(text: widget.item?.title);
    _dropdownController = TextEditingController();

    if (widget.item != null) {
      selectedDate = widget.item?.dateTime;

      if (selectedDate != null && !widget.item!.allDay) {
        selectedTime = TimeOfDay.fromDateTime(selectedDate!);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<DropdownMenuEntry<int>> _getDropdownItems() {
    var categories = _categoryProvider?.getCategories();
    var items = <DropdownMenuEntry<int>>[];

    for (var category in categories!) {
      if (category.id != null) {
        items.add(DropdownMenuEntry<int>(
          value: category.id!,
          label: category.name,
        ));
      }
    }

    return items;
  }

  DateTime _combineDateTimeAndTimeOfDay(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  void _saveItem() {
    var fullDateTime = selectedDate;

    if (selectedDate != null && selectedTime != null) {
      fullDateTime = _combineDateTimeAndTimeOfDay(selectedDate!, selectedTime!);
    }

    var newItem = TodoItem(
        title: _controller.text,
        dateTime: fullDateTime,
        allDay: selectedTime == null && selectedDate != null);

    widget.onSubmit(newItem);
  }

  @override
  Widget build(BuildContext context) {
    String dateText = selectedDate == null
        ? 'Data'
        : DateFormat('dd/MM/yyyy').format(selectedDate!);

    String timeText = selectedTime == null || selectedDate == null
        ? 'Hora'
        : selectedTime!.format(context);

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        _saveItem();
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
                      ElevatedButton(
                        onPressed: selectedDate != null
                            ? () async {
                                var pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.dial);

                                setState(() {
                                  selectedTime = pickedTime;
                                });
                              }
                            : null,
                        child: Text(timeText),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownMenu<int>(
                    label: const Text('Categoria'),
                    onSelected: (int? value) {
                      setState(() {});
                    },
                    dropdownMenuEntries: _getDropdownItems(),
                    initialSelection: widget.item?.categoryId,
                  )
                ],
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formItemPageKey.currentState!.validate()) {
              _saveItem();
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

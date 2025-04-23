import 'package:flutter/material.dart';
import 'package:todo_flutter/models/category.dart';

class CategoryDialog extends StatefulWidget {
  final Category? category;
  final Function(String)? onSave;
  const CategoryDialog({super.key, this.category, this.onSave});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  late TextEditingController _controller;
  final GlobalKey<FormState> _formItemPageKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.category?.name);
  }

  void _save() {
    if (_formItemPageKey.currentState!.validate()) {
      if (widget.onSave != null) {
        widget.onSave!(_controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.category == null ? "Adicionar Categoria" : "Editar Categoria"),
      content: Form(
        key: _formItemPageKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nome',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira um nome';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            _save();
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _save();
          },
          child: Text('Salvar'),
        )
      ],
    );
  }
}

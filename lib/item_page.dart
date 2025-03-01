import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Salvar
          Navigator.pop(context);
        },
        tooltip: "Salvar",
        child: Icon(Icons.check,),
      ),
    );
  }
}

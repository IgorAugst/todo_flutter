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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Título',
              ),
            )
          ],
        )),
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

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/item_page.dart';
import 'package:todo_flutter/item_widget.dart';
import 'package:todo_flutter/todo_provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => TodoProvider()),
    ],
    child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      //home: const ItemPage()
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("ToDo"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return ListView.builder(itemCount: todoProvider.itemCount ,itemBuilder: (BuildContext context, int index) {
            return ItemWidget(index: index);
          });
        }
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemPage())
            );
          },
          tooltip: 'Adicionar',
          child: Icon(Icons.add)),
    );
  }
}

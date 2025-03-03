
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
      body: Column(
        children: [
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return ListView.builder(shrinkWrap: true ,itemCount: todoProvider.undoneItemCount ,itemBuilder: (BuildContext context, int index) {
                return ItemWidget(index: index, isDone: false,);
              });
            }
          ),
          Divider(height: 10, thickness: 1, indent: 0, endIndent: 0, color: Colors.black12),
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return ListView.builder(shrinkWrap: true ,itemCount: todoProvider.doneItemCount ,itemBuilder: (BuildContext context, int index) {
                return ItemWidget(index: index, isDone: true,);
              });
            }
          ),
        ],
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

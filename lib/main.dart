
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


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Theme.of(context).colorScheme.primaryContainer;

    return Scaffold(
      appBar: AppBar(
          title: Text("ToDo"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              tileColor: _selectedIndex == 0 ? selectedColor : null,
              title: Text("Início"),
              onTap: () {
                _onItemTapped(0);
              },
            ),
            ListTile(
              tileColor: _selectedIndex == 1 ? selectedColor : null,
              title: Text("Concluídos"),
              onTap: () {
                _onItemTapped(1);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return ListView.builder(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), itemCount: todoProvider.getTodoItemCount(done: false) ,itemBuilder: (BuildContext context, int index) {
                  return ItemWidget(item: todoProvider.getTodoItems(done: false)[index]);
                });
              }
            ),
            Divider(height: 10, thickness: 1, indent: 0, endIndent: 0, color: Colors.black12),
            Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return ListView.builder(shrinkWrap: true, physics: NeverScrollableScrollPhysics() ,itemCount: todoProvider.getTodoItemCount(done: true) ,itemBuilder: (BuildContext context, int index) {
                  return ItemWidget(item: todoProvider.getTodoItems(done: true)[index]);
                });
              }
            ),
          ],
        ),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/category.dart';
import 'package:todo_flutter/item_page.dart';
import 'package:todo_flutter/item_widget.dart';
import 'package:todo_flutter/todo_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
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
  Category _selectedCategory = Category();
  late TodoProvider _todoProvider;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedCategory = _todoProvider.categories[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Theme.of(context).colorScheme.primaryContainer;

    return Consumer<TodoProvider>(builder: (context, todoProvider, child) {
      _todoProvider = todoProvider;
      return Scaffold(
        appBar: AppBar(
            title: Text(_selectedCategory.name),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary),
        drawer: Drawer(
          child: ListView.builder(
            itemCount: todoProvider.categoryCount,
            itemBuilder: (context, index){
              return ListTile(
                tileColor: index == _selectedIndex ? selectedColor : null,
                title: Text(todoProvider.categories[index].name),
                onTap: (){
                  _onItemTapped(index);
                  Navigator.pop(context);
                },
              );
            },
          )
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: todoProvider.getTodoItemCount(done: _selectedCategory.isDone),
                  itemBuilder: (BuildContext context, int index) {
                    return ItemWidget(
                        item: todoProvider.getTodoItems(done: _selectedCategory.isDone)[index]);
                  }),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ItemPage())).then((_){
                    _onItemTapped(0);
              });
            },
            tooltip: 'Adicionar',
            child: Icon(Icons.add)),
      );
    });
  }
}

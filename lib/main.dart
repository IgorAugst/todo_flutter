import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_flutter/models/category.dart';
import 'package:todo_flutter/models/todo_item.dart';
import 'package:todo_flutter/pages/item_page.dart';
import 'package:todo_flutter/providers/selection_provider.dart';
import 'package:todo_flutter/providers/todo_provider.dart';
import 'package:todo_flutter/repositories/notification_repository.dart';
import 'package:todo_flutter/widgets/item_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationRepository.initNotifications();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://91304806a6f9ccfe6c0edc8f1203b2d3@o4509120722173952.ingest.us.sentry.io/4509125670928384';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      options.experimental.replay.onErrorSampleRate = 1.0;
    },
    appRunner: () => runApp(SentryWidget(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TodoProvider()),
          ChangeNotifierProvider(create: (_) => SelectionProvider())
        ],
        child: MyApp(),
      ),
    )),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: Foundation.kDebugMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [const Locale('pt')],
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
  late SelectionProvider _selectionProvider;
  bool _isSelecting = false;
  //final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _selectDrawer(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedCategory = _todoProvider.categories[index];
      if (_isSelecting) {
        _clearSelection();
      }
    });
  }

  void _openItemTap({required BuildContext context, TodoItem? item}) {
    if (!_isSelecting || item == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemPage(
                    title: item == null ? "Adicionar" : "Editar",
                    item: item,
                    onSubmit: (newItem) {
                      if (item == null) {
                        _todoProvider.addItem(newItem);
                      } else {
                        _todoProvider.updateItem(item.updateFrom(newItem));
                      }
                    },
                  ))).then((_) {
        _selectDrawer(0);
      });
    } else {
      _onItemLongPress(item);
    }
  }

  void _onItemLongPress(TodoItem item) {
    setState(() {
      _selectionProvider.toggleSelection(item);
    });

    _isSelecting = _selectionProvider.length() > 0;
  }

  void _deleteSelection() {
    for (var item in _selectionProvider.selectedItems) {
      _todoProvider.removeItem(item);
      _selectionProvider.clearSelection();
      _isSelecting = false;
    }
  }

  void _deleteItem(TodoItem item) {
    _todoProvider.removeItem(item);
  }

  void _clearSelection() {
    setState(() {
      _selectionProvider.clearSelection();
      _isSelecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Theme.of(context).colorScheme.primaryContainer;

    return Consumer2<TodoProvider, SelectionProvider>(
        builder: (context, todoProvider, selectionProvider, child) {
      _todoProvider = todoProvider;
      _selectionProvider = selectionProvider;

      return PopScope(
        canPop: _selectedIndex == 0 && !_isSelecting,
        onPopInvokedWithResult: (didPop, result) {
          if (!_isSelecting) {
            _selectDrawer(0);
          } else {
            _clearSelection();
          }
        },
        child: GestureDetector(
          onTap: () {
            if (_isSelecting) {
              _clearSelection();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(_selectedCategory.name),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: <Widget>[
                AnimatedOpacity(
                  opacity: _selectionProvider.length() != 0 ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  child: IconButton(
                      onPressed: () {
                        _deleteSelection();
                      },
                      icon: const Icon(Icons.delete)),
                )
              ],
            ),
            drawer: Drawer(
                child: ListView.builder(
              itemCount: todoProvider.categoryCount,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: index == _selectedIndex ? selectedColor : null,
                  title: Text(todoProvider.categories[index].name),
                  onTap: () {
                    _selectDrawer(index);
                    Navigator.pop(context);
                  },
                );
              },
            )),
            drawerEdgeDragWidth: MediaQuery.of(context).size.width / 4,
            body: SingleChildScrollView(
              child: ImplicitlyAnimatedList<TodoItem>(
                  areItemsTheSame: (TodoItem a, TodoItem b) => a.id == b.id,
                  shrinkWrap: true,
                  items: todoProvider.getTodoItems(
                      category: _selectedCategory),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, animation, item, int index) {
                    return SizeFadeTransition(
                      sizeFraction: 0.7,
                      curve: Curves.easeInOut,
                      animation: animation,
                      child: Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children:[
                            SlidableAction(
                              onPressed: (context) {
                                _deleteItem(item);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            )
                          ]
                        ),
                        child: Material(
                          color: selectionProvider.checkSelection(item)
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : null,
                          child: ItemWidget(
                            key: ValueKey(item.id),
                            item: item,
                            onToggle: todoProvider.toggleItem,
                            onTap: (item) {
                              _openItemTap(context: context, item: item);
                            },
                            onLongPress: (item) {
                              _onItemLongPress(item);
                            },
                            showCheckbox: !_isSelecting,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            floatingActionButton: AnimatedOpacity(
              opacity: _isSelecting ? 0 : 1,
              duration: Duration(milliseconds: 200),
              child: FloatingActionButton(
                  onPressed: _isSelecting
                      ? null
                      : () {
                          _openItemTap(context: context);
                        },
                  tooltip: 'Adicionar',
                  child: Icon(Icons.add)),
            ),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class AppState extends ChangeNotifier {
  var tasks = ["Task 1","Task 2"];
  var temp_edit = "";

  //void changeTask

  void addTask(String name) {
    tasks.add(name);
    notifyListeners();
    print("New task added: " + name);
  }

  Widget _addDialog(BuildContext context) {
    return AlertDialog(
      title: Text('New task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Text("Create a task"),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: TextField(
            onChanged: (String change) {temp_edit=change;print(change);},
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Task name',
            ),
          ),
        ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            addTask(temp_edit);
            Navigator.pop(context);
          },
          child: const Text('Add task'),
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child:MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeConfig.darkTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Home'),
      ),
    );
  }
}

class AppColors {
  static const Color primary = Color(0xFF52698B);
  static const Color secondary = Color(0xFF2C303F);
  static Color tertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF121125)
        : const Color(0xFF121125);
  }
}

class ThemeConfig {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Color(0xFF121125),
    colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: AppColors.secondary,
        onSurface: Colors.white
    )
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.secondary,
    scaffoldBackgroundColor: Color(0xFF121125),
    colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: AppColors.secondary,
        onSurface: Colors.white
    )
  );
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  
  

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(0.8),
        child:Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child:Padding(
                padding: const EdgeInsets.all(30.0),
                child: TaskDisplay(),
              )
            ),
          ]
        )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print("+ button pressed");
          showDialog<void>(
                  context: context,
                  useRootNavigator: true, // ignore: avoid_redundant_argument_values
                  builder: appState._addDialog,
          );
        },
        tooltip: 'New task',
        child: const Icon(Icons.add),
      ), //

      bottomNavigationBar: BottomNavBar(),
      
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TaskDisplay extends StatelessWidget {
  const TaskDisplay({super.key});
  
  @override
  Widget build(BuildContext context) {
    var taskAppState = context.watch<AppState>();
    return Flexible(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              shrinkWrap: true,
              children: [
              Container(
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                children: [
                  for (int i=0; i<taskAppState.tasks.length; i++)
                  Padding(padding: const EdgeInsets.all(15.0),
                          child:ListTile(
                            title:Text(taskAppState.tasks[i]),
                            splashColor: Theme.of(context).colorScheme.primary,),),
                  ]
              )
              )
              ],
            ),
      ),
    );
  }
  
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentPageIndex = 1;

  Widget _buildDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Unavailable'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("This section of the app is currently unavailable."),
          Text("Stay tuned for more updates!")
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        onDestinationSelected: (int index) {
          showDialog<void>(
                  context: context,
                  useRootNavigator: true, // ignore: avoid_redundant_argument_values
                  builder: _buildDialog,
          );
        },
        indicatorColor: Theme.of(context).colorScheme.primary,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Badge(label: Text('2'), child: Icon(Icons.circle)),
            label: 'To-do',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book),
            label: 'Classes',
          ),
        ],
    );
  }
}
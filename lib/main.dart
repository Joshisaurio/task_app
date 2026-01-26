import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';


void main() {
  runApp(const MyApp());
}

class AppState extends ChangeNotifier {
  var tasks = <List>[];
  var tempEdit = "";
  bool isInputValid = false;

  //void changeTask

  void addTask(String name) {
    tasks.add([name]);
    notifyListeners();
    //print("New task added: " + name);
  }

  void addTaskFromInput() {
    tasks.add([tempEdit]);
    tempEdit="";
    validateInput(tempEdit);
  }

  void validateInput (String input) {
    isInputValid = input.isNotEmpty;
    notifyListeners();
  }

  Widget _addDialog(BuildContext context) {
    var appState = context.watch<AppState>();
    return AlertDialog(
      title: Text('New task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: TextField(
            onChanged: (String change) {tempEdit=change;validateInput(change);},
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
          child: const Text('Cancel', style:TextStyle(color:Colors.white),),
        ),
        TextButton(
          style: !appState.isInputValid ? ButtonStyle(backgroundColor: WidgetStateColor.transparent,overlayColor: WidgetStateColor.transparent,) : ButtonStyle(),
          onPressed: () {
            if(appState.isInputValid) {
            addTaskFromInput();
            Navigator.pop(context);
            }
          },
          child: Text('Add task', style:TextStyle(
            color: appState.isInputValid ? Colors.white : Colors.grey,
            ),),
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
      title: 'Task app',
      theme: ThemeConfig.mainTheme,
      darkTheme: ThemeConfig.mainTheme,
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
  
  // THEME CONFIG //

  static ThemeData mainTheme = ThemeData(
    // FONT & TEXT
    fontFamily: 'Inter',
    textTheme: TextTheme(
      // HEADLINE:
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
      ),

      // TITLES
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle( // There was no subtitle so I used titleSmall as a subtitle
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      // BODY
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),

    ),

    // COLOR SCHEME
    primaryColor: AppColors.secondary,
    scaffoldBackgroundColor: Color(0xFF121125),
    brightness: Brightness.dark,

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
    ),

    // OTHER
    useMaterial3: true,
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

    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(0, 30, 0, 0),

        //   PAGE CONTENT START   //
        // Page content goes here //

        child:ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: Text("Home", style: Theme.of(context).textTheme.headlineLarge),
            ),
            TaskDisplay(),
          ],
        ),

        //    PAGE CONTENT END    //
        // Page content ends here //

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog<void>(
                  context: context,
                  useRootNavigator: true, // ignore: avoid_redundant_argument_values
                  builder: appState._addDialog,
          );
        },
        tooltip: 'New task',
        child: const Icon(Symbols.add_rounded, weight:500),
      ),

      bottomNavigationBar: BottomNavBar(),
    );
  }
}

/*
// FOR LOOP EXAMPLES: //
children:[
for (int i; i<10; i++)
  Widget()
]


children:[
for (int i=0; i<taskAppState.tasks.length; i++)
  Padding(padding: const EdgeInsets.all(15.0),
          child:ListTile(
            title:Text(taskAppState.tasks[i][0]),
            splashColor: Theme.of(context).colorScheme.primary,),),
]
*/


class TaskDisplay extends StatelessWidget {
  const TaskDisplay({super.key});
  
  @override
  Widget build(BuildContext context) {
    var taskAppState = context.watch<AppState>();
    return Card(
    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
    color: Theme.of(context).colorScheme.secondary,
    elevation: 0.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
    ),
    
    // TASK DISPLAY START //
    
    child: ListTile(
      title: Text("Tasks",style:Theme.of(context).textTheme.titleMedium),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
            if (taskAppState.tasks.length > 1)
              Text("You have ${taskAppState.tasks.length.toString()} pending tasks.", style:Theme.of(context).textTheme.bodyMedium)
            else
              if (taskAppState.tasks.isEmpty)
                Text("You have no tasks yet. Press the + button below to add a task.",style:Theme.of(context).textTheme.bodyMedium)
              else
                Text("You have one pending task.",style:Theme.of(context).textTheme.bodyMedium),
            

            for (int i=0; i<taskAppState.tasks.length; i++)
              Card(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2000.0), // Adjust the radius as needed
                ),
                elevation: 0.0,
                color: Theme.of(context).colorScheme.primary,
                child: ListTile(
                  leading: Icon(Symbols.task_alt_rounded, fill:1),
                  title:Text(taskAppState.tasks[i][0], style:Theme.of(context).textTheme.bodyMedium),
                  ),
              ),
          ],
        ),
        ),
    
    // TASK DISPLAY END //
    
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
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          //DecoratedBox(decoration: BoxDecoration(color:Colors.blue), child: Row(children: [Icon(Symbols.settings)]),),
          NavigationDestination(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing:10.0,
              children: [
                SizedBox(width:1, height: 5,),
                Badge(label: Text('0'), child: Icon(Symbols.task_rounded, fill:1)),
                Text("To-Do"),
                SizedBox(width:1, height: 5,),
              ],
            ),
            label: 'To-do',
          ),
          NavigationDestination(
            icon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing:10.0,
                children: [
                  SizedBox(width:1, height: 5,),
                  Icon(Symbols.home_rounded, fill:1),
                  //Text("Home"),
                  SizedBox(width:1, height: 5,),
                ],
              ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing:10.0,
              children: [
                SizedBox(width:1, height: 5,),
                Icon(Symbols.book_rounded, fill:1),
                Text("Classes"),
                SizedBox(width:1, height: 5,),
              ],
            ),
            label: 'Classes',
          ),
        ],
    );
  }
}
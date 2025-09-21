import 'package:flutter/material.dart';

//everything starts from here runapp tells Flutter
// runApp() takes MyApp() as an argument, which is a widget
// and tells Flutter to start building the widget tree.
//(this is actually me talking, i am trying to understand the code myself)
void main() {
  runApp(const MyApp());
}

//Stateless widgets cannot change their state over time.
//Making this a Stateful widget in order to have the app be able to change from dark mode to light
// This widget is the root of your application.
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => MyAppState();
}

//State class for MyApp
//Stores current theme (light or dark)
//Provides the toggle function to switch themes
class MyAppState extends State<MyApp> {
  //this variable keeps track of the current theme
  ThemeMode _mode = ThemeMode.light;

  //This method switches between light and dark
  //setState() makes Flutter rebuild the UI so it shows up
  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  //The build method here makes the overall app structure
  //Everything is wrapped in MaterialApp (root widget)
  //This provides user light and dark settings
  //MyHomePage is the main screen
  //Gives MyHomePage toggle, function to switch themes, and isDark tells it which theme is active.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Light Dark Theme Demo',

      //In charge of how light mode looks
      themeMode: _mode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 231, 36, 227),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      //In charge of how dark mode looks
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      //Sets first screen user sees
      //onToggleTheme is the function to switch themes
      //isDark tells which one is active
      home: MyHomePage(
        title: 'Counter and Image Toggle',
        onToggleTheme: _toggleTheme,
        isDark: _mode == ThemeMode.dark,
      ),
    );
  }
}

//Declares MyHomePage as a StatefulWidget, meaning it has a mutable state
//The CLASS is immutable though

class MyHomePage extends StatefulWidget {
  //Constructor for MyHomePage
  //This is how you create the MyHomePage object
  //required means you have to provide these values when creating it
  //refers to the properties of the class, all of these are on the previous block of code
  const MyHomePage({
    super.key,
    required this.title,
    required this.onToggleTheme,
    required this.isDark,
  });

  //Configuration values for widget
  //final means that these cannot be changed once widget is created
  final String title;
  final VoidCallback onToggleTheme;
  final bool isDark;

  //Connects widget MyHomePage to its mutable state class _MyHomePageState
  //It actually creates the state object
  //This is where the actual logic, the changing of variables, and build method() are
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// we are going to add more comments tmr but for now this is fine
class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  bool _showFirst = true;

  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() => _counter++);
  }

  Future<void> _toggleImage() async {
    await _controller.reverse();
    setState(() => _showFirst = !_showFirst);
    await _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final imgPath = _showFirst
        ? 'assets/images/img1.png'
        : 'assets/images/img2.png';

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Counter: $_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text('Increment'),
              ),

              const SizedBox(height: 30),

              FadeTransition(
                opacity: _fade,
                child: Image.asset(
                  imgPath,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _toggleImage,
                child: const Text('Toggle Image'),
              ),

              const SizedBox(height: 30),

              OutlinedButton(
                onPressed: widget.onToggleTheme,
                child: Text(
                  widget.isDark
                      ? 'Switch to Light Mode'
                      : 'Switch to Dark Mode',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

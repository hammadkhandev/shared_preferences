import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Shares_preferences'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;
  late Future<bool> _repeat;

  Future<void> _changeBoolValue() async{
    final SharedPreferences prefs = await _prefs;
    bool value = (prefs.getBool('repeat') ?? false);
    value = !value;
    setState(() {
      _repeat = prefs.setBool('repeat', value).then((bool success) => value);
    });
  }

  /// await prefs.setBool('repeat', true);
// Save an double value to 'decimal' key.
 /// await prefs.setDouble('decimal', 1.5);
// Save an String value to 'action' key.
 /// await prefs.setString('action', 'Start');
// Save an list of strings to 'items' key.
 /// await prefs.setStringList('items', <String>['Earth', 'Moon', 'Sun']);

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt('counter', counter).then((bool success) {
        return counter;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _counter = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('counter') ?? 0;
    });
    _repeat = _prefs.then((SharedPreferences preferences) {
      return preferences.getBool('repeat') ?? false; });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences Demo'),
      ),
      persistentFooterButtons: [
        IconButton(onPressed: _changeBoolValue, icon: Icon(Icons.abc))
      ],
      body: Center(
          child: ListView(
            children: [
              FutureBuilder<int>(
                  future: _counter,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(
                            'Button tapped ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.\n\n'
                                'This should persist across restarts.',
                          );
                        }
                    }
                  }),
              SizedBox(height: 10,),
              FutureBuilder<bool>(
                  future: _repeat,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                       return const CircularProgressIndicator();
                      case ConnectionState.active:
                      case ConnectionState.done:
                      if(snapshot.hasError){
                        return Text('Error ${snapshot.data}');
                  }else {
                        return Text('bool value ${snapshot.data}');
                  }
                  }
                  }),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

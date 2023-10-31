import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // var current = WordPair.random();  --this was from the codelab
  
  // USE THIS AS THE METHOD TO CALL DATABAST, ETC
  void login() {
    print('user logged in');
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('Welcome to CCI Stat Tracker!'),
          Text('Username: '),
          Text('Password: '),

          // login button
          ElevatedButton(
            onPressed: () {
            print('login pressed!');
            appState.login();
          },
          child: Text('Login'),
          )
        ],
      ),
    );
  }
}
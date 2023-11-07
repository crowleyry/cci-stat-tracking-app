// import 'package:english_words/english_words.dart';
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
        title: 'CCI Stat Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: LoginPage(),
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

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to CCI Stat Tracker!'),
            Text('Username: '),
            Text('Password: '),
      
            // login button
            ElevatedButton(
              onPressed: () {
              print('login pressed!');
              appState.login();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateStatsPage()),
              );
            },
            child: Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}

class UpdateStatsPage extends StatelessWidget { // this page is where the team will input their stats while doing evangelism
  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row( // TODO: this row should contain the headers 'solo' and 'partner' to identify the counters
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Solo'),
              Text('Partner'),
            ],
          ),
          Row( // TODO: copy/paste this for each of the other stat categories (maybe make this a widget?)
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Initiations:'),
              Text('0'),
              Text('0'),
              OutlinedButton( // button to increase solo init stat
                onPressed: () {
                  print('solo init + pressed');
                },
                child: Text('+ Solo'),
              ),
              OutlinedButton( // button to decrease solo init stat
                onPressed: () {
                  print('solo init - pressed');
                },
                child: Text('- Solo'),
              ),
              OutlinedButton( // button to increase partner init stat
                onPressed: () {
                  print('partner init + pressed');
                },
                child: Text('+ Partner'),
              ),
              OutlinedButton( // button to decrease partner init stat
                onPressed: () {
                  print('partner init - pressed');
                },
                child: Text('- Partner'),
              ),
            ],
          ),
          Text('Spiritual Conversations:'),
          Text('Gospel Conversations:'),
          Text('Prayers to Receive Christ:'),
          
          // back button to navigate to login page (probably temporary)
          ElevatedButton(
            onPressed: () {
              print('back button pressed');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Back'),
          )
        ],
      )
    );
  }
}
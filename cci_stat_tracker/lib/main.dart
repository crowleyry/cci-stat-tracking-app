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
          Row( // initiations row
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
          Row( // Spiritual convo row
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Spiritual Conversations:'),
              Text('0'),
              Text('0'),
              OutlinedButton( // button to increase solo spir convo stat
                onPressed: () {
                  print('solo spir convo + pressed');
                },
                child: Text('+ Solo'),
              ),
              OutlinedButton( // button to decrease solo spir convo stat
                onPressed: () {
                  print('solo spir convo - pressed');
                },
                child: Text('- Solo'),
              ),
              OutlinedButton( // button to increase partner spir convo stat
                onPressed: () {
                  print('partner spir convo + pressed');
                },
                child: Text('+ Partner'),
              ),
              OutlinedButton( // button to decrease partner spir convo stat
                onPressed: () {
                  print('partner spir convo - pressed');
                },
                child: Text('- Partner'),
              ),
            ],
          ),
          Row( // Gospel convo row
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Gospel Conversations:'),
              Text('0'),
              Text('0'),
              OutlinedButton( // button to increase solo GC stat
                onPressed: () {
                  print('solo GC + pressed');
                },
                child: Text('+ Solo'),
              ),
              OutlinedButton( // button to decrease solo GC stat
                onPressed: () {
                  print('solo GC - pressed');
                },
                child: Text('- Solo'),
              ),
              OutlinedButton( // button to increase partner GC stat
                onPressed: () {
                  print('partner GC + pressed');
                },
                child: Text('+ Partner'),
              ),
              OutlinedButton( // button to decrease partner GC stat
                onPressed: () {
                  print('partner GC - pressed');
                },
                child: Text('- Partner'),
              ),
            ],
          ),
          Row( // PRC row
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Prayers to Receive Christ:'),
              Text('0'),
              Text('0'),
              OutlinedButton( // button to increase solo PRC stat
                onPressed: () {
                  print('solo PRC + pressed');
                },
                child: Text('+ Solo'),
              ),
              OutlinedButton( // button to decrease solo PRC stat
                onPressed: () {
                  print('solo PRC - pressed');
                },
                child: Text('- Solo'),
              ),
              OutlinedButton( // button to increase partner PRC stat
                onPressed: () {
                  print('partner PRC + pressed');
                },
                child: Text('+ Partner'),
              ),
              OutlinedButton( // button to decrease partner PRC stat
                onPressed: () {
                  print('partner PRC - pressed');
                },
                child: Text('- Partner'),
              ),
            ],
          ),
          
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
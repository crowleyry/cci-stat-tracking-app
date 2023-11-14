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

   var stats = [0, 0, 0, 0, 0, 0, 0, 0]; // list of stats (init solo, init partner, sc solo, sc partner, etc...)

  
  // USE THIS AS THE METHOD TO CALL DATABASE, ETC
  void login() {
    print('user logged in');
    notifyListeners();
  }

  void incStat(var theStat) { // increment specific stat in stats list
    stats[theStat]++;
    notifyListeners();
  }
  void decStat(var theStat) { // decrement specific stat in stats list 
    if(stats[theStat] > 0) { // stat cannot be negative
      stats[theStat]--;
    }
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

class UpdateStatsPage extends StatelessWidget { // this page is where the team will input their stats while doing outreach
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold( // TODO: update this to be a ListTile (so much easier...)
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row( // row for headers
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
              Text(appState.stats[0].toString()), // solo text
              Text(appState.stats[1].toString()), // partner text
              OutlinedButton( // button to increase solo init stat
                onPressed: () {
                  appState.incStat(0); // increment init solo
                  print('solo init + pressed');
                },
                child: Text('+ Solo'),
              ),
              OutlinedButton( // button to decrease solo init stat
                onPressed: () {
                  appState.decStat(0); // decrement init solo
                  print('solo init - pressed');
                },
                child: Text('- Solo'),
              ),
              OutlinedButton( // button to increase partner init stat
                onPressed: () {
                  appState.incStat(1);
                  print('partner init + pressed');
                },
                child: Text('+ Partner'),
              ),
              OutlinedButton( // button to decrease partner init stat
                onPressed: () {
                  appState.decStat(1);
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
              Text(appState.stats[2].toString()),
              Text(appState.stats[3].toString()),
              OutlinedButton( // button to increase solo spir convo stat
                onPressed: () {
                  appState.incStat(2);
                  print('solo spir convo + pressed');
                },
                child: Text('+ Solo'),
              ),
              OutlinedButton( // button to decrease solo spir convo stat
                onPressed: () {
                  appState.decStat(2);
                  print('solo spir convo - pressed');
                },
                child: Text('- Solo'),
              ),
              OutlinedButton( // button to increase partner spir convo stat
                onPressed: () {
                  appState.incStat(3);
                  print('partner spir convo + pressed');
                },
                child: Text('+ Partner'),
              ),
              OutlinedButton( // button to decrease partner spir convo stat
                onPressed: () {
                  appState.decStat(3);
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
              Text(appState.stats[4].toString()),
              Text(appState.stats[5].toString()),
              OutlinedButton( // button to increase solo GC stat
                onPressed: () {
                  appState.incStat(4);
                  print('solo GC + pressed');
                },
                child: Text('+ Solo'),
              ),
              OutlinedButton( // button to decrease solo GC stat
                onPressed: () {
                  appState.decStat(4);
                  print('solo GC - pressed');
                },
                child: Text('- Solo'),
              ),
              OutlinedButton( // button to increase partner GC stat
                onPressed: () {
                  appState.incStat(5);
                  print('partner GC + pressed');
                },
                child: Text('+ Partner'),
              ),
              OutlinedButton( // button to decrease partner GC stat
                onPressed: () {
                  appState.decStat(5);
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
              Text(appState.stats[6].toString()),
              Text(appState.stats[7].toString()),
              OutlinedButton( // button to increase solo PRC stat
                onPressed: () {
                  appState.incStat(6);
                  print('solo PRC + pressed');
                },
                child: Text('+ Solo'),
              ),
              OutlinedButton( // button to decrease solo PRC stat
                onPressed: () {
                  appState.decStat(6);
                  print('solo PRC - pressed');
                },
                child: Text('- Solo'),
              ),
              OutlinedButton( // button to increase partner PRC stat
                onPressed: () {
                  appState.incStat(7);
                  print('partner PRC + pressed');
                },
                child: Text('+ Partner'),
              ),
              OutlinedButton( // button to decrease partner PRC stat
                onPressed: () {
                  appState.decStat(7);
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
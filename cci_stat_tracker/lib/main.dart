// import 'package:english_words/english_words.dart';
// DONT WORRY ABOUT DATE RANGES YET, JUST USE THE USER AS THE TOP LEVEL IN THE DATABASE AND GET THINGS READING/WRITING
// ANGULAR/REACT WEBSITE TO INTERACT WITH DATABASE (JONAH)
// trying to write data to firebase, not working... LOOK INTO DEFAULT FIREBASE OPTIONS (https://firebase.flutter.dev/docs/firestore/example)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  //FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference test = FirebaseFirestore.instance.collection('entries');
  
  // USE THIS AS THE METHOD TO CALL DATABASE, ETC
  void login() {
    print('user logged in');
    
    test.doc("WZEAIppxMYujbxZar0Ys").get().then((DocumentSnapshot documentSnapshot) {
      print("inside function");
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      }
      else {
        print('Document does not exist...');
      }
    });
    
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
    // var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Stats")
      ),
      body: Center(
        child: ListView(
          children: [
            InitSoloListTile(), InitPartnerListTile(), SCSoloListTile(), SCPartnerListTile(), GCSoloListTile(), GCPartnerListTile(), PRCSoloListTile(), PRCPartnerListTile()
          ]
        ),
      )
    );
  }
}

class InitSoloListTile extends StatelessWidget { // listtile for init solo stat
  const InitSoloListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          appState.decStat(0); // decrement init solo
          print('solo init - pressed');
        },
      ),
      title: Center(child: Text(appState.stats[0].toString())),
      subtitle: Center(child: Text('Initiations Solo')),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          appState.incStat(0); // increment init solo
          // db.collection("entries").doc("WZEAIppxMYujbxZar0Ys").update({"inits": appState.stats[0]}).then(
          //   (value) => print("DocumentSnapshot successfully updated!"),
          //   onError: (e) => print("Error updating document $e"));
          print('solo init + pressed');
        },
      ),
    );
  }
}

class InitPartnerListTile extends StatelessWidget { // listtile for init partner stat
  const InitPartnerListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          appState.decStat(1); // decrement init solo
          print('partner init - pressed');
        },
      ),
      title: Center(child: Text(appState.stats[1].toString())),
      subtitle: Center(child: Text('Initiations with Partner')),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          appState.incStat(1); // increment init solo
          print('parnter init + pressed');
        },
      ),
    );
  }
}

class SCSoloListTile extends StatelessWidget { // listtile for sc solo stat
  const SCSoloListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          appState.decStat(2); // increment init solo
          print('solo sc - pressed');
        },
      ),
      title: Center(child: Text(appState.stats[2].toString())),
      subtitle: Center(child: Text('Spiritual Conversations Solo')),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          appState.incStat(2); // increment init solo
          print('solo sc + pressed');
        },
      ),
    );
  }
}

class SCPartnerListTile extends StatelessWidget { // listtile for sc partner stat
  const SCPartnerListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          appState.decStat(3); // increment init solo
          print('partner sc + pressed');
        },
      ),
      title: Center(child: Text(appState.stats[3].toString())),
      subtitle: Center(child: Text('Spiritual Conversations with Partner')),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          appState.incStat(3); // increment init solo
          print('partner sc + pressed');
        },
      ),
    );
  }
}

class GCSoloListTile extends StatelessWidget { // listtile for gc solo stat
  const GCSoloListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          appState.decStat(4); // decrement gc solo
          print('solo gc + pressed');
        },
      ),
      title: Center(child: Text(appState.stats[4].toString())),
      subtitle: Center(child: Text('Gospel Conversations Solo')),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          appState.incStat(4); // increment gc solo
          print('solo gc + pressed');
        },
      ),
    );
  }
}

class GCPartnerListTile extends StatelessWidget { // listtile for gc partner stat
  const GCPartnerListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          appState.decStat(5); // decrement gc partner
          print('partner gc - pressed');
        },
      ),
      title: Center(child: Text(appState.stats[5].toString())),
      subtitle: Center(child: Text('Gospel Conversations with Partner')),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          appState.incStat(5); // increment gc partner
          print('partner gc + pressed');
        },
      ),
    );
  }
}

class PRCSoloListTile extends StatelessWidget { // listtile for prc solo stat
  const PRCSoloListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          appState.decStat(6); // decrement prc solo
          print('solo prc - pressed');
        },
      ),
      title: Center(child: Text(appState.stats[6].toString())),
      subtitle: Center(child: Text('Prayers to Receive Christ Solo')),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          appState.incStat(6); // increment prc solo
          print('solo prc + pressed');
        },
      ),
    );
  }
}

class PRCPartnerListTile extends StatelessWidget { // listtile for prc partner stat
  const PRCPartnerListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          appState.decStat(7); // decrement prc partner
          print('partner prc - pressed');
        },
      ),
      title: Center(child: Text(appState.stats[7].toString())),
      subtitle: Center(child: Text('Prayers to Receive Christ with Partner')),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          appState.incStat(7); // increment prc partner
          print('partner prc + pressed');
        },
      ),
    );
  }
}
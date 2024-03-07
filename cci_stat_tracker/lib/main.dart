// import 'package:english_words/english_words.dart';
// DONT WORRY ABOUT DATE RANGES YET, JUST USE THE USER AS THE TOP LEVEL IN THE DATABASE AND GET THINGS READING/WRITING
// ANGULAR/REACT WEBSITE TO INTERACT WITH DATABASE (JONAH)
// trying to write data to firebase, not working... LOOK INTO DEFAULT FIREBASE OPTIONS (https://firebase.flutter.dev/docs/firestore/example)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cci_stat_tracker/UpdateStats/init.dart';
import 'package:cci_stat_tracker/UpdateStats/spir.dart';
import 'package:cci_stat_tracker/UpdateStats/gc.dart';
import 'package:cci_stat_tracker/UpdateStats/prc.dart';
import 'package:cci_stat_tracker/UpdateStats/nmu.dart';
import 'package:cci_stat_tracker/UpdateStats/phone_num.dart';
import 'package:cci_stat_tracker/UpdateStats/hours.dart';


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
  //final docRef = FirebaseFirestore.instance.collection('entries').doc("WZEAIppxMYujbxZar0Ys");
  // docRef.snapshots().listen(
  //   (event) => print("current data: ${event.data()}"),
  //   onError: (error) => print("Listen failed: $error"),
  // );
  
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
                    MaterialPageRoute(builder: (context) => UserStats()),
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

// class UpdateStatsPage extends StatelessWidget { // this page is where the team will input their stats while doing outreach
//   @override
//   Widget build(BuildContext context) {
//     // var appState = context.watch<MyAppState>();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Update Stats")
//       ),
//       body: Center(
//         child: ListView(
//           children: [
//             InitSoloListTile(), InitPartnerListTile(), SCSoloListTile(), SCPartnerListTile(), GCSoloListTile(), GCPartnerListTile(), PRCSoloListTile(), PRCPartnerListTile()
//           ]
//         ),
//       )
//     );
//   }
// }

enum ButtonItems { Solo, Partner}


class UpdateStatsPage extends State<UserStats> { // this page is where the team will input their stats while doing outreach
  final Stream<QuerySnapshot> _entriesStream =
      FirebaseFirestore.instance.collection('entries').snapshots();
  
  final entriesRef = FirebaseFirestore.instance.collection('entries');

  
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _entriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        
        return Scaffold(
          appBar: AppBar(
            title: Text("Update Stats")
          ),
          body: Center(
            child: ListView(
              children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  // title: Text(data['inits_solo'].toString()),
                  // subtitle: Text(data['hours_solo'].toString()),
                  leading: PopupMenuButton(
                    icon: Icon(Icons.remove),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'so',
                        child: TextButton(
                          child: Text("Solo"),
                          onPressed: () {
                            // decrement value in database
                            entriesRef.doc(document.id).update(
                              {"Solo": FieldValue.increment(-1)},
                            );

                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 'pa',
                        child: TextButton(
                          child: Text('Partner'),
                          onPressed: () {
                            // decrement value in database
                            entriesRef.doc(document.id).update(
                              {"Partner": FieldValue.increment(-1)},
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  title: Center(child: Text('Solo: ' + data['Solo'].toString() + ', Partner: ' + data['Partner'].toString())),
                  subtitle: Center(child: Text(document.id.toString())),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.add),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'so',
                        child: TextButton(
                          child: Text("Solo"),
                          onPressed: () {
                            // increment value in database
                            entriesRef.doc(document.id).update(
                              {"Solo": FieldValue.increment(1)},
                            );
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 'pa',
                        child: TextButton(
                          child: Text('Partner'),
                          onPressed: () {
                            // increment value in database
                            entriesRef.doc(document.id).update(
                              {"Partner": FieldValue.increment(1)},
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              })
              .toList()
              .cast(),
            ),
          )
        );
      }
    );
  }
}

class UserStats extends StatefulWidget {
  @override
  UpdateStatsPage createState() => UpdateStatsPage();
}

















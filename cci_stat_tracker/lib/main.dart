// import 'package:english_words/english_words.dart';
// DONT WORRY ABOUT DATE RANGES YET, JUST USE THE USER AS THE TOP LEVEL IN THE DATABASE AND GET THINGS READING/WRITING
// ANGULAR/REACT WEBSITE TO INTERACT WITH DATABASE (JONAH)
// trying to write data to firebase, not working... LOOK INTO DEFAULT FIREBASE OPTIONS (https://firebase.flutter.dev/docs/firestore/example)
import 'dart:ffi';

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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';



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
        home: LoginPageState(),
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
  
  Future<void> login(var emailAddress, var password) async {
    print('user logged in');
    
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found with that email.');
      } else if (e.code == 'wrong-password'){
        print('Wrong password provided for that user.');
      }
    }

    notifyListeners();
  }

  Future<void> createAccount(var emailAddress, var password) async {
    print('user is creating account...');
    // final the_stats = <String, dynamic>{
    //   "Solo" : 0, 
    //   "Partner" : 0
    // };
    Map<String, Map<String, dynamic>> the_stats = {
      mostRecentMonday(): {'Solo': 0, 'Partner': 0}
    };
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailAddress, password: password);
      db.collection(emailAddress.toString()).doc("Initiations").set(the_stats);
      print("created init doc");
      db.collection(emailAddress.toString()).doc("Spiritual Conversations").set(the_stats);
      db.collection(emailAddress.toString()).doc("Gospel Conversations").set(the_stats);
      db.collection(emailAddress.toString()).doc("Prayers to Receive Christ").set(the_stats);
      db.collection(emailAddress.toString()).doc("New Meetups").set(the_stats);
      db.collection(emailAddress.toString()).doc("Phone Numbers").set(the_stats);
      db.collection(emailAddress.toString()).doc("Hours").set(the_stats);
      login(emailAddress, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }


  String mostRecentMonday() { // returns formatted string of the date of the most recent Monday according to local timezone
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    return DateFormat('yyyy-MM-dd').format(monday);
  }

  String getNextMonday() {
    DateTime now = DateTime.now();
    int daysUntilMonday = DateTime.monday - now.weekday;
    if (daysUntilMonday <= 0) {
      daysUntilMonday += 7; // If today is Monday or later, move to next Monday
    }
    DateTime nextMonday = now.add(Duration(days: daysUntilMonday));
    String formattedDate = DateFormat('yyyy-MM-dd').format(nextMonday);
    return formattedDate;
}

  Future<void> isItSunday(var emailAddress) async {
    
    print('creating next Monday data field');
    Map<String, Map<String, dynamic>> the_stats = {
      getNextMonday(): {'Solo': 0, 'Partner': 0}
    };
    FirebaseFirestore db = FirebaseFirestore.instance;
    
    if (DateTime.now() == DateTime.sunday) {
      db.collection(emailAddress.toString()).doc("Initiations").set(the_stats);
      db.collection(emailAddress.toString()).doc("Spiritual Conversations").set(the_stats);
      db.collection(emailAddress.toString()).doc("Gospel Conversations").set(the_stats);
      db.collection(emailAddress.toString()).doc("Prayers to Receive Christ").set(the_stats);
      db.collection(emailAddress.toString()).doc("New Meetups").set(the_stats);
      db.collection(emailAddress.toString()).doc("Phone Numbers").set(the_stats);
      db.collection(emailAddress.toString()).doc("Hours").set(the_stats);
    }
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

class LoginPageState extends StatefulWidget {
  const LoginPageState({super.key});

  @override
  State<LoginPageState> createState() => LoginPage();
}

class CreateAccountPageState extends StatefulWidget {
  const CreateAccountPageState({super.key});

  @override
  State<CreateAccountPageState> createState() => CreateAccountPage();
}

class LoginPage extends State<LoginPageState> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  @override
  void emailDispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  void passDispose() {
    passController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to CCI Stat Tracker!'),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your CCI email',
              ),
            ),
            TextField(
              controller: passController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
      
            // login button
            ElevatedButton(
              onPressed: () {
                print('login pressed!');
                  appState.login(emailController.text, passController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserStats()),
                );
            },
            child: Text('Login'),
            ),
            ElevatedButton(
              child: Text('Create Account'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccountPageState()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class CreateAccountPage extends State<CreateAccountPageState> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final passAgainController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void emailDispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  void passDispose() {
    passController.dispose();
    super.dispose();
  }
  @override
  void passAgainDispose() {
    passAgainController.dispose();
    super.dispose();
  }
  @override
  void nameDispose() {
    nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create Account'),
            // TextField(
            //   controller: nameController,
            //   decoration: InputDecoration(
            //     labelText: 'First and Last Name',
            //     hintText: 'Enter your name',
            //   ),
            // ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Use your CCI email',
              ),
            ),
            TextField(
              controller: passController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
            TextField(
              controller: passAgainController,
              decoration: InputDecoration(
                labelText: 'Re-type Password',
                hintText: 'Enter your password again',
              ),
            ),
            
            // login button
            ElevatedButton(
              onPressed: () {
                print('submit pressed!');
                if (passController.text != passAgainController.text) {
                  print('passwords dont match');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('Passwords must match.'),
                        actions: [
                          TextButton(
                            child: Text('Done'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CreateAccountPageState()),
                              );
                            }
                          )
                        ],
                      );
                    },
                  );
                }
                else {
                  appState.createAccount(emailController.text, passController.text);
                  //appState.login();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserStats()),
                );
                }
            },
            child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}


class UpdateStatsPage extends State<UserStats> { // this page is where the team will input their stats while doing outreach
  //var user = FirebaseAuth.instance.currentUser;
  
  // final Stream<QuerySnapshot> _entriesStream =
  //     FirebaseFirestore.instance.collection(user.uid).snapshots();
  
  //final entriesRef = FirebaseFirestore.instance.collection('entries');

  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theUser;
    String thisWeek = appState.mostRecentMonday();

    if (FirebaseAuth.instance.currentUser != null) {
      theUser = FirebaseAuth.instance.currentUser?.email;
      appState.isItSunday(theUser);
    }
    final Stream<QuerySnapshot> _entriesStream =
       FirebaseFirestore.instance.collection(theUser.toString()).snapshots();

    final entriesRef = FirebaseFirestore.instance.collection(theUser.toString());

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
            title: Text("Welcome, " + theUser.toString()),
            automaticallyImplyLeading: false,
            actions: [
              TextButton(
                child: Text('Log Out'),
                onPressed: () {
                  appState.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPageState()),
                );
                },
              )
            ]
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
                              {'$thisWeek.Solo': FieldValue.increment(-1)},
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
                              {'$thisWeek.Partner': FieldValue.increment(-1)},
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  title: Center(child: Text('Solo: ${data[thisWeek]['Solo']}, Partner: ${data[thisWeek]['Partner']}')),
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
                              {'$thisWeek.Solo': FieldValue.increment(1)},
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
                              {'$thisWeek.Partner': FieldValue.increment(1)},
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

















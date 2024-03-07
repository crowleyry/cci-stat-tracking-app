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
import 'package:firebase_auth/firebase_auth.dart';


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
  
  // USE THIS AS THE METHOD TO CALL DATABASE, ETC
  void login() {
    print('user logged in');
    
    notifyListeners();
  }

  Future<void> createAccount(var emailAddress, var password) async {
    print('user is creating account...');

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
                  appState.login();
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
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create Account'),
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
                  appState.login();
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

















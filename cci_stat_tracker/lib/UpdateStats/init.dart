import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cci_stat_tracker/main.dart';


class InitSoloListTile extends State<Inititations> { // listtile for init solo stat
  //const InitSoloListTile({Key? key}) : super(key: key);
  final Stream<QuerySnapshot> _entriesStream =
      FirebaseFirestore.instance.collection('entries').snapshots();

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    return StreamBuilder<QuerySnapshot>(
      stream: _entriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // get the data from stream and turn it into a map
        snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  leading: IconButton (
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    print('dec solo inits pressed');
                  },
                  ),
                  title: Center(child: Text(data["inits_solo"])),
                  subtitle: Center(child: Text("Initiations Solo")),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      print('inc solo inits pressed');
                    },
                  ),
                );
              });
        return ListTile();
      },
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

class Inititations extends StatefulWidget {
  @override
  InitSoloListTile createState() => InitSoloListTile();
}
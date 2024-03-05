import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cci_stat_tracker/main.dart';


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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cci_stat_tracker/main.dart';


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
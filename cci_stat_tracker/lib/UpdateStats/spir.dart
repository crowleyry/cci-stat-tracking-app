import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cci_stat_tracker/main.dart';


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
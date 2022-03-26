import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

class ExampleRW extends StatefulWidget {
  const ExampleRW({Key? key}) : super(key: key);

  @override
  _ExampleRWState createState() => _ExampleRWState();
}

class _ExampleRWState extends State<ExampleRW> {
  final database = FirebaseDatabase.instance.ref();
  late StreamSubscription userChangeStream;
  //some state that the display is based on, in this example we'll display each user id in a box
  Map<String, dynamic> users = {};

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }
  @override
  void deactivate() {
    userChangeStream.cancel();//cancel the listener at end of page
    super.deactivate();
  }
  void _activateListeners(){
    //we'll look at and then listen for any changes to all of the user ids
    userChangeStream = database.child('users').onValue.listen((event) {
      final Map<String, dynamic> usersData = event.snapshot.value as Map<String, dynamic>;
      setState(() {
        users = usersData;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: database.child('users').orderByKey().limitToFirst(10).onValue,
          builder: (context, snapshot){
            final tilesList = <ListTile>[];
            if(snapshot.hasData){
              final myData = Map<String, dynamic>.from(
                  (snapshot.data! as dynamic).snapshot.value);
              myData.forEach((key, value) {
                // final nextOrder = Map<String, dynamic>.from(value);
                final orderTile = ListTile(
                  leading: const Icon(Icons.local_cafe),
                  title: Text(key)
                );
                tilesList.add(orderTile);
              });

            }
          return Expanded(child: ListView(children: tilesList));
        }
        ),
    );
  }
}

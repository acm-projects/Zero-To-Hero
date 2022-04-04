import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'EditGoalPage.dart';


class AllGoalsPage extends StatefulWidget {
  final String uid;

  const AllGoalsPage({Key? key,  required this.uid }) : super(key: key);

  @override
  State<AllGoalsPage> createState() => _AllGoalsPageState();
}

class _AllGoalsPageState extends State<AllGoalsPage> {
  final database = FirebaseDatabase.instance.ref();
  late StreamSubscription goalChangeStream;
  List<Goal> dynamicGoals = <Goal>[];

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }
  @override
  void deactivate() {
    goalChangeStream.cancel();//cancel the listener at end of page
    super.deactivate();
  }
  void _activateListeners(){
    //we'll look at and then listen for any changes to all of the user ids
    goalChangeStream = database.child('users/${widget.uid}/allGoals').onValue.listen((event) {
      List<Goal> tempDynamicGoals = <Goal>[];
      final Map<String, dynamic> usersData = jsonDecode(jsonEncode(event.snapshot.value));
      //we just need the goal id, and the description, and doneToday
      for(String gid in usersData.keys){
        Goal thisGoal = Goal(title: usersData[gid]['description']);
        thisGoal.isCompleted = usersData[gid]['completedToday'] ?? false;
        thisGoal.gid = gid;
        tempDynamicGoals.add(thisGoal);
      }
      setState(() {
        dynamicGoals = [];
        dynamicGoals = List.from(tempDynamicGoals);
      });
    });
  }
  void changeGoalCompleted(Goal goal, bool value){
    database.child('users/${widget.uid}/allGoals/${goal.gid}')
        .update({"completedToday": value});
  }
  Widget buildSingleDynamicCheckbox(Goal goal) => ListTile(
      //controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        goal.title,
        style: const TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 116, 111, 109),
        ),
      ),
      trailing: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            //reroute to Edit Goal page here
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => EditGoalPage(uid: widget.uid, gid: goal.gid)),
            );
          }
      )

  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'All Goals',
            style: TextStyle(
              color: Colors.white,
            )
        ),
        backgroundColor: const Color.fromARGB(255, 166, 189, 240),
      ),
      body: ListView (
        children: [
          Column(children: dynamicGoals.map(buildSingleDynamicCheckbox).toList())
        ],
      ),
    );
  }
}

class Goal {
  final String title;
  bool isCompleted;
  late String gid;

  Goal({
    required this.title,
    this.isCompleted = false,
  });
}
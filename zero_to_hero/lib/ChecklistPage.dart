import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zero_to_hero/NewGoalPage.dart';
import 'package:zero_to_hero/EditGoalPage.dart';


class ChecklistPage extends StatefulWidget {
  final String uid;

  const ChecklistPage({Key? key, required this.uid }) : super(key: key);

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
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
  Widget buildSingleDynamicCheckbox(Goal goal) => CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color.fromARGB(255, 255, 188, 151),
      value: goal.isCompleted,
      onChanged: (value) => changeGoalCompleted(goal, value!),
      title: Text(
        goal.title,
        style: const TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 116, 111, 109),
        ),
      ),
      secondary: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () {
          //reroute to Edit Goal page here
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => EditGoalPage())
          );
        }
      )
  );

  bool value= false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Daily Goals',
          style: TextStyle(
            color: Colors.white,
          )
        ),
        backgroundColor: const Color.fromARGB(255, 166, 189, 240),
      ),
      body: ListView (
        children: [
          Column(children: dynamicGoals.map(buildSingleDynamicCheckbox).toList()),

          //View All button
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ElevatedButton(
              onPressed: () {
                //reroute to All Goals page here
              },
              //make button rounded
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 188, 151)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
              ),

              child: const Text(
                  'View All'

              ),

            ),
          )


        ],
      ),




      
      //add goal button
      floatingActionButton: FloatingActionButton(
        child: const IconTheme(
          data: IconThemeData(
              color: Colors.white), //change icon to white
          child: Icon(
              Icons.add,  //add icon
              size: 50),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 188, 151),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewGoalPage(uid: widget.uid))
          );
        },
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

// class Goal extends StatelessWidget {
//
//   Goal({@required this.onPressed});
//
//   final GestureTapCallback onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return Text: "testing";
//   }
//
// }
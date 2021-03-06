import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zero_to_hero/NewGoalPage.dart';
import 'package:zero_to_hero/EditGoalPage.dart';
import 'package:zero_to_hero/AllGoalsPage.dart';


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
      String dayOfWeek = DateFormat('EEEE').format(DateTime.now());
      for(String gid in usersData.keys){
        if(!usersData[gid]['activeDays'][dayOfWeek])
          continue;
        Goal thisGoal = Goal(title: usersData[gid]['description']);
        thisGoal.isCompleted = usersData[gid]['completedToday'] ?? false;
        thisGoal.isImport = usersData[gid]['isImportant'] ?? false;
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
    addCompletedNumber(value);

  }

  FontWeight getWeight(bool val)
  {
    if(val)
      {
        return FontWeight.w900;
      }
    else
      {
        return FontWeight.normal;
      }
  }
  Future<void> addCompletedNumber(bool val) async
  {
    final db = FirebaseDatabase.instance.ref('users/${widget.uid}');
    DatabaseEvent event = await db.once();
    dynamic data = event.snapshot.value;
    if(data != null)
    {
      int curGoals = data['totalGoalsCompleted'];
      if(val == true)
        {
          curGoals++;
        }
      else
        {
          curGoals--;
        }
      database.child('users/${widget.uid}').update({"totalGoalsCompleted": curGoals});
    }

  }
  Widget buildSingleDynamicCheckbox(Goal goal) => CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color.fromARGB(255, 255, 188, 151),
      value: goal.isCompleted,
      onChanged: (value) => changeGoalCompleted(goal, value!),
      title: Text(
        goal.title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: getWeight(goal.isImport),
          color: const Color.fromARGB(255, 116, 111, 109),
        ),
      ),
      secondary: IconButton(
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
          ...dynamicGoals.map(buildSingleDynamicCheckbox).toList(),

          //View All button
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ElevatedButton(
              onPressed: () {
                //reroute to All Goals page here
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllGoalsPage(uid: widget.uid)));
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
          ),

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
  bool isImport;

  Goal({
    required this.title,
    this.isCompleted = false,
    this.isImport = false

});
}


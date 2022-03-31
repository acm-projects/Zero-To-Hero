import 'package:flutter/material.dart';
import 'package:zero_to_hero/NewGoalPage.dart';
import 'package:zero_to_hero/AllGoalsPage.dart';


class ChecklistPage extends StatefulWidget {
  final String uid;

  const ChecklistPage({Key? key, required this.uid }) : super(key: key);

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  bool value= false;

  final goals = [
    Goal(title: 'Excersize for 30 minutes'),
    Goal(title: 'Water plants'),
    Goal(title: 'Cook dinner'),
    Goal(title: 'Drink 2 liters of water'),
  ];

  Widget buildSingleCheckbox(Goal goal) => CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color.fromARGB(255, 255, 188, 151),
      value: goal.isCompleted,
      onChanged: (value) => setState(() => goal.isCompleted = value!),
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
        }
      )





  );
  @override

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
          ...goals.map(buildSingleCheckbox).toList(),

          //View All button
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ElevatedButton(
              onPressed: () {
                //reroute to All Goals page here
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllGoalsPage())
                  );
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
import 'package:flutter/material.dart';
import 'NewGoalPage.dart';
import 'CalendarPage.dart';
import 'package:intl/intl.dart';

class CalendarDayPage extends StatefulWidget {
  final String uid;
  final DateTime date;
  final List<Goal> completed;
  //List of Not Completed Goals
  final List<Goal> notCompleted;
  //Number of total and completed goals
  final int totalGoals;
  final int completedGoals;
  const CalendarDayPage({Key? key, required this.uid, required this.date, required this.completed, required this.totalGoals, required this.completedGoals, required this.notCompleted}) : super(key: key);
  @override
  _CalendarDayPageState createState() => _CalendarDayPageState();
}

class _CalendarDayPageState extends State<CalendarDayPage> {
  //List of Completed Goals


  //Translated DateTime object into standard epoch time
  int getEpochTime(DateTime time)
  {
    return time.millisecondsSinceEpoch + 3600000;

  }
  bool t = true;
  Widget buildSingleCheckbox(Goal goal) => Text(
      goal.title,
      style: const TextStyle(
        fontSize: 15,
      )

      );


  //Instantiates Data when page is opened
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MM-dd').format(widget.date);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            formattedDate,
            style: const TextStyle(
              color: Colors.white,
            )
        ),
        backgroundColor: const Color.fromARGB(255, 166, 189, 240),
      ),
      body: ListView (
        children: [
          const Text("Statistics", style: TextStyle(
            color: Color.fromARGB(255, 166, 189, 240),
            fontSize: 25,
          )),
          const Text("Goals Done", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),
          Text("$completedGoals/${widget.totalGoals}", style: const TextStyle(
            fontSize: 15,
          )),
          const Text("Completed", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),
          ...widget.completed.map(buildSingleCheckbox).toList(),
          const Text("Not Completed", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),
          ...widget.notCompleted.map(buildSingleCheckbox).toList(),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              //make button rounded
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 166, 189, 240)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
              ),

              child: const Text(
                  'Close Statistics'

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
  Goal({
    required this.title,
  });
}
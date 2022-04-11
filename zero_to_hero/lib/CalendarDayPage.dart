import 'package:flutter/material.dart';
import 'NewGoalPage.dart';
import 'CalendarPage.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
  dynamic showGoals(List<Goal> goals)
  {
    if(goals.isNotEmpty)
      {
        return goals.map(buildSingleCheckbox).toList();
      }
    else
      {
        return showNone();
      }
  }
  Widget buildSingleCheckbox(Goal goal) => Text(
      goal.title,
      style: const TextStyle(
        fontSize: 15,
      )

      );

  Widget showNone()
  {
    return const Text(
      "None!",style: TextStyle(
        fontSize: 15),);
  }


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
      body: SingleChildScrollView (
        padding: const EdgeInsets.all(15.0),
        child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              const Text("Statistics", style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25,
              )),
              const SizedBox(height: 12),
              const Text("Completed goals", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
              ...widget.completed.map(buildSingleCheckbox).toList(),
              const SizedBox(height: 12),
              const Text("Not completed goals", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
              ...widget.notCompleted.map(buildSingleCheckbox).toList(),
              const SizedBox(height: 15),
              CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 13.0,
                animation: true,
                percent: widget.completedGoals/widget.totalGoals,
                center:   Text(
                  "$completedGoals/${widget.totalGoals}",
                  style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                footer: const Text(
                  "Goals Completed",
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: const Color.fromARGB(255, 255, 188, 151),
              ),


            ],
        ),
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
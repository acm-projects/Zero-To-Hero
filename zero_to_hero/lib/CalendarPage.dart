import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'CalendarDayPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class CalendarPage extends StatefulWidget {
  final String uid;

  const CalendarPage({Key? key, required this.uid}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

List<Goal> completed = <Goal>[];
//List of Not Completed Goals
List<Goal> notCompleted = <Goal>[];
//Number of total and completed goals
int totalGoals = 0;
int completedGoals = 0;
var goalStream;
int getEpochTime(DateTime time)
{
  return time.millisecondsSinceEpoch + 3600000;
}

//late UserModel userData;


class _CalendarPageState extends State<CalendarPage> {
  int goalsDone = 0;
  int totalGoals = 0;
  int curStreak = 0;
  int longestStreak = 0;

  Future<void> isNull(DateTime time) async
  {
    final database = FirebaseDatabase.instance.ref('users/${widget.uid}/calendarDays/${getEpochTime(time)}');
    DatabaseEvent event = await database.once();
    dynamic data = event.snapshot.value;
    if(data != null)
      {
        completed.clear();
        notCompleted.clear();
        completedGoals = 0;
        totalGoals = 0;
        for(final key in data.keys)
        {

          if(data[key]["completed"] == true)
          {
            completed.add(Goal(title: data[key]["description"]));
            completedGoals++;
          }
          else
          {
            notCompleted.add(Goal(title: data[key]["description"]));
          }
          totalGoals++;
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CalendarDayPage(uid: widget.uid, date: time, completed: completed,
              notCompleted: notCompleted, totalGoals: totalGoals, completedGoals: completedGoals,)));
      }
  }

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  @override
  void deactivate() {
    goalStream.cancel();//cancel the listener at end of page
    super.deactivate();
  }

  void _activateListeners() {
    //we'll look at and then listen for any changes to all of the user ids
    final db = FirebaseDatabase.instance.ref();
    goalStream = db.child('users/${widget.uid}').onValue.listen((event){
      dynamic usersData = event.snapshot.value;
      //we just need the goal id, and the description, and doneToday
      setState(() {
        goalsDone = usersData['totalGoalsCompleted'];
        totalGoals = usersData['totalGoals'];
        longestStreak = usersData['longestStreak'];
        curStreak = usersData['streak'];
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
              'Achievements',
              style: TextStyle(
                color: Colors.white,
              )
          ),
          backgroundColor: const Color.fromARGB(255, 166, 189, 240),
        ),

        body: Container(
            padding: EdgeInsets.all(15.0),
            child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  TableCalendar(
                      onDaySelected: (DateTime o, DateTime p){
                          isNull(o);
                      },
                      firstDay: DateTime.utc(2022, 1, 1),
                      lastDay: DateTime.utc(2060, 12, 31),
                      focusedDay: DateTime.now(),
                      headerVisible: true,
                      daysOfWeekVisible: true,

                    //calendar style
                    calendarStyle: const CalendarStyle(
                      defaultDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 188, 151),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 166, 189, 240),
                        shape: BoxShape.circle,
                      ),
                      weekendDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 188, 151),
                        shape: BoxShape.circle,
                      ),
                    ),

                    //header style
                    headerStyle: const HeaderStyle(
                      titleTextStyle: TextStyle(
                          color: Color.fromARGB(255, 166, 189, 240),
                          fontSize: 23,
                          fontWeight: FontWeight.bold
                      ),
                      formatButtonVisible: false,
                    ),

                    //change bubble colors based on percent complete
                    calendarBuilders: CalendarBuilders (
                        defaultBuilder: (context, day, focusedDay){
                          Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 188, 151),
                                  shape: BoxShape.circle
                              )
                          );
                        }
                    ),

                    //route to statistics for each day

                      );
                    }


                ),

                  const SizedBox(height: 15),
                  const Text (
                      'Statistics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      )
                  ),
                  const SizedBox(height: 15),
                  const Text (
                      'Total Goals Completed:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )
                  ),
                      Text (
                      '$goalsDone/$totalGoals',
                      style: const TextStyle(
                        fontSize: 18,
                      )
                  ),
                  const SizedBox(height: 12),
                  const Text (
                      'Longest streak:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )
                  ),
                      Text (
                      '$longestStreak days',
                      style: const TextStyle(
                        fontSize: 18,
                      )
                  ),
                  const SizedBox(height: 12),
                  const Text (
                      'Current Streak',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )
                  ),
                       Text (
                      '$curStreak days',
                      style: const TextStyle(
                        fontSize: 18,
                      )
                  ),
                ]
            )

        )
    );
  }
}
// ListView(
//   children: <Widget> [Container (
//     height: 50,
//     child: const Text (
//       'Statistics'
//     )
//   )]
// )


// const Padding(
// padding: EdgeInsets.all(20),
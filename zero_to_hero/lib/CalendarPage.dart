import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'CalendarDayPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';

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

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
class _CalendarPageState extends State<CalendarPage> {
  int goalsDone = 0;
  int totalGoals = 0;
  int curStreak = 0;
  int longestStreak = 0;
  Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

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
        print(totalGoals);
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
    initSelectedDays();
  }
  Future<void> initSelectedDays() async {
    final database = FirebaseDatabase.instance.ref('users/${widget.uid}/calendarDays/');
    DatabaseEvent event = await database.once();
    Map<String, dynamic> data = jsonDecode(jsonEncode(event.snapshot.value));

    for(var day in data.keys){
      DateTime curDay = DateTime.fromMillisecondsSinceEpoch(int.parse(day) ).add(Duration(days: 1));
      print(curDay.isUtc);
      int completedGoals2 = 0;
      int totalGoals2 = 0;
      for(final goal in data[day].keys) {
        if(data[day][goal]["completed"] == true) {
          completedGoals2++;
        }
        totalGoals2++;
      }
      if(totalGoals2 == completedGoals2){
        _selectedDays.add(curDay);
      }
    }
    print(_selectedDays);
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
            child: SingleChildScrollView
              (
            child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  TableCalendar(
                      selectedDayPredicate: (day){
                        return _selectedDays.contains(day);
                      },
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
                        todayDecoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 188, 151),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Color.fromARGB(255, 166, 189, 240),
                          shape: BoxShape.circle,
                        ),
                      ),

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
                      )


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
                  const SizedBox(height: 15),
                  CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 13.0,
                    animation: true,
                    percent: goalsDone/totalGoals,
                    center:   Text(
                      "$goalsDone/${totalGoals}",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    footer: const Text(
                      "Total Goals Completed",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: const Color.fromARGB(255, 255, 188, 151),
                  ),
                  const SizedBox(height: 12),
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
        )
    );
  }
}

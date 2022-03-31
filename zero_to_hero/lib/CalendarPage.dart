import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zero_to_hero/Statistics.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
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

        body: SingleChildScrollView (
          padding: const EdgeInsets.all(15.0),
          child: Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                TableCalendar(
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
                    onDaySelected: (selectedDay, focusedDay) {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Statistics())
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
                const Text (
                    '58/246',
                    style: TextStyle(
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
                const Text (
                    '9 days',
                    style: TextStyle(
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
                const Text (
                    '4 days',
                    style: TextStyle(
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
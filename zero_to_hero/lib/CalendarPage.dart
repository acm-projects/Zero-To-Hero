import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'CalendarDayPage.dart';

class CalendarPage extends StatefulWidget {
  final String uid;

  const CalendarPage({Key? key, required this.uid }) : super(key: key);
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

      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            TableCalendar(
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2060, 12, 31),
                focusedDay: DateTime.now(),
                headerVisible: true,
                daysOfWeekVisible: true,
                onDaySelected: (DateTime o, DateTime p){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CalendarDayPage(uid: widget.uid, date: o)));
                  print(o.toString());
                },
                headerStyle: const HeaderStyle(
                  titleTextStyle: TextStyle(
                    color: Color.fromARGB(255, 166, 189, 240),
                    fontSize: 23,
                  ),
                  formatButtonVisible: false,

                )

            ),

            const SizedBox(height: 10),
            const Text (
                'Statistics',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                )
            ),
            const SizedBox(height: 7),
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
            const SizedBox(height: 5),
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
            const SizedBox(height: 5),
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
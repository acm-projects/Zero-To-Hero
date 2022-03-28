import 'package:flutter/material.dart';
import 'package:zero_to_hero/model/UserModel.dart';
import 'CalendarPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zero_to_hero/model/UserModel.dart';
import 'package:async/async.dart';

class CalendarDayPage extends StatefulWidget {
  final String uid;
  final DateTime date;
  const CalendarDayPage({Key? key, required this.uid, required this.date}) : super(key: key);
  @override
  _CalendarDayPageState createState() => _CalendarDayPageState();
}

class _CalendarDayPageState extends State<CalendarDayPage> {
  UserModel user = UserModel('temp');

  int getEpochTime(DateTime time)
  {
    return time.millisecondsSinceEpoch + 3600000;
  }

    late UserModel userData;
  Future<void> getData() async
  {
    final database = FirebaseDatabase.instance.ref('users/${widget.uid}/calendarDays/${getEpochTime(widget.date)}');
    DatabaseEvent event = await database.once();

// Print the data of the snapshot
    //print(event.snapshot.value);


    //dynamic data = database.onValue;
    //final Map<String, dynamic> usersData = event.snapshot.value as Map<String, dynamic>;
     // UserModel userData = UserModel.fromRTDB(widget.uid, usersData);
    dynamic data = event.snapshot.value;
      //dynamic temp = data.keys;
      //print(data);
      for(final key in data.keys)
      {
          print(data[key]["description"]);
      }
      //print(data[]);
      // temp.forEach((goalID) => {
      //   print(goalID),
      //   print("hi")
      // });
    //print(userData.calendarDays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text(
        'Goal',
        style: TextStyle(
        color: Colors.white,
    )

    ),
    backgroundColor: const Color.fromARGB(255, 166, 189, 240),
    ),
        body: Padding(
    padding: const EdgeInsets.all(20),
    child: SingleChildScrollView(
    child: Container(
    child: Column(children: [
      ElevatedButton(
        onPressed:() => {
          print(getEpochTime(widget.date)),
          getData()
        },
        child: const Text('Add new reminder'),
        style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(255, 166, 189, 240),
          onPrimary: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          minimumSize: Size(370, 35),
        ),
      ),
    ]
    )
    )
    )
        )
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zero_to_hero/CalendarDayPage.dart';
import 'package:zero_to_hero/model/GoalModel.dart';
import 'package:firebase_database/firebase_database.dart';

class EditGoalPage extends StatefulWidget {
  final String uid;
  final String gid;

  const EditGoalPage({Key? key, required this.uid, required this.gid}) : super(key: key);

  @override
  _EditGoalPageState createState() => _EditGoalPageState();
}

class _EditGoalPageState extends State<EditGoalPage> {
  final database = FirebaseDatabase.instance.ref();
  late StreamSubscription goalStream;

  List<Reminder> allRemin = [];
  Map<String, bool> reminders = {};
  String _selectedTime = "";
  //Time Picker
  Future<void> _show() async {
    final TimeOfDay? result =
    await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
    );
    if (result != null) {
      setState(() {
        _selectedTime = result.format(context);
        reminders[_selectedTime] = true;
        allRemin.add(Reminder(time: _selectedTime));
      });
    }
  }
  Widget buildSingleReminder(Reminder reminder) => Text(
      reminder.time.toString(),
      style: const TextStyle(
        fontSize: 15,
      )
  );

  TextEditingController descController = TextEditingController();
  final remindController = TextEditingController();
  GoalModel data = GoalModel("", {});

  //Switch conditions
  Map<String, bool> daysOfWeek = {
    'Sunday': false,
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false
  };

  Widget buildSingleDayCheckbox(String dayOfWeek) => Transform.scale(
    scale: 2.0,
    child: Checkbox(

      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      checkColor: Colors.white,
      activeColor: const Color.fromARGB(255, 255, 224, 206),
      // fillColor: Color.fromARGB(255, 255, 224, 206),
      shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(10.0))),
      side: const BorderSide(
          width: 1.0,
          color: Color.fromARGB(255, 166, 189, 240)),
      value: daysOfWeek[dayOfWeek],
      onChanged: (value) {
        setState(() {
          daysOfWeek[dayOfWeek] = value!;
        });
      },
    ),
  );

  void editData() {
    data.reminders = reminders;
    data.activeDays = daysOfWeek;
    data.description = descController.text;
    final ref = database.child('users/${widget.uid}/allGoals/${widget.gid}');
    ref.update(data.toMap());
  }

  void deleteGoal(){
    database.child('users/${widget.uid}/allGoals/${widget.gid}').remove();
  }

  @override
  void initState() {
    super.initState();
    final ref = database.child('users/${widget.uid}/allGoals/${widget.gid}');
    goalStream = ref.onValue.listen((event) {
      setState(() {
        data = GoalModel.fromRTDB(widget.gid, jsonDecode(jsonEncode(event.snapshot.value)));
        descController = TextEditingController(text: data.description);
        for(String dayOfWeek in daysOfWeek.keys){
          daysOfWeek[dayOfWeek] = data.activeDays[dayOfWeek] ?? false;
        }
        // daysOfWeek = data.activeDays;
        reminders = data.reminders;
        //@TODO convert this epoch time to the HH:MM AM/PM format
        allRemin = reminders.keys.map((e) => Reminder(time: e)).toList();
      });
    });
  }
  @override
  void deactivate() {
    goalStream.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 166, 189, 240),
          title: const Text(
            'Edit Goal:',
            style: TextStyle(color: Colors.white),
          )),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(children: [
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            SizedBox(
              height: 30,
              // width: double.infinity,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 0, top: 0, right: 260, bottom: 0),
                child: const Text(
                  "Description:",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 116, 111, 109),
                  ),
                ),
              ),
            ),
            TextField(
              controller: descController,
              minLines: 2,
              cursorColor: const Color.fromARGB(255, 56, 56, 56),
              style: const TextStyle(color: Color.fromARGB(255, 56, 56, 56)),
              decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 255, 224, 206),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 224, 206)))),
              maxLines: 3,
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 0, top: 40, right: 60, bottom: 0),
                child: const Text(
                  "What days of the week should you complete this goal?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 116, 111, 109),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    margin: const EdgeInsets.only(
                        left: 0, top: 25, right: 1, bottom: 0),
                    child: const Text(
                      "Sun",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 116, 111, 109),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    margin: const EdgeInsets.only(
                        left: 0, top: 25, right: 0, bottom: 0),
                    child: const Text(
                      "Mon",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 116, 111, 109),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    margin: const EdgeInsets.only(
                        left: 0, top: 25, right: 0, bottom: 0),
                    child: const Text(
                      "Tue",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 116, 111, 109),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    margin: const EdgeInsets.only(
                        left: 0, top: 25, right: 0, bottom: 0),
                    child: const Text(
                      "Wed",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 116, 111, 109),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    margin: const EdgeInsets.only(
                        left: 0, top: 25, right: 3, bottom: 0),
                    child: const Text(
                      "Thu",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 116, 111, 109),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    margin: const EdgeInsets.only(
                        left: 0, top: 25, right: 0, bottom: 0),
                    child: const Text(
                      "Fri",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 116, 111, 109),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    margin: const EdgeInsets.only(
                        left: 5, top: 25, right: 0, bottom: 0),
                    child: const Text(
                      "Sat",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 116, 111, 109),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(final dayOfWeek in daysOfWeek.keys)
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      buildSingleDayCheckbox(dayOfWeek),
                      const SizedBox(width: 4)
                    ],
                  ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 0, top: 30, right: 60, bottom: 0),
                child: const Text(
                  "When do you want Reminders?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 116, 111, 109),
                  ),
                ),
              ),
            ),
            const Text("    "),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _show,
                  child: const Text('Add new reminder'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 166, 189, 240),
                    onPrimary: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 17,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    minimumSize: const Size(370, 40),
                  ),
                ),
              ],
            ),

            //Displaying the time
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...allRemin.map(buildSingleReminder).toList(),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 60.0),
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        // deleteGoal();
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(const Color.fromARGB(255, 240, 139, 139)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                               Colors.white),
                          overlayColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 240, 139, 139)),
                          minimumSize:
                          MaterialStateProperty.all(const Size(368, 15)),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          side: MaterialStateProperty.all(const BorderSide(
                            color: Color.fromARGB(255, 133, 152, 199),
                          ))),
                      child: const Text(
                        'Delete Goal',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )),
                ),
              ],
            ),
            //Row for buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 1.0),
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        print('I got clicked');
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 116, 111, 109)),
                          overlayColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 240, 139, 139)),
                          minimumSize:
                          MaterialStateProperty.all(const Size(120, 50)),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          side: MaterialStateProperty.all(const BorderSide(
                            color: Color.fromARGB(255, 133, 152, 199),
                          ))),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                ),
                const Text("    "),
                Container(
                  margin: const EdgeInsets.only(top: 1.0),
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        print('I got clicked');
                        editData();
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 166, 189, 240)),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        overlayColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 133, 152, 199)),
                        minimumSize:
                        MaterialStateProperty.all(const Size(234, 50)),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
                      ),
                      child: const Text(
                        'Save Changes:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class Reminder {
  final String? time;
  Reminder({
    required this.time,
  });
}
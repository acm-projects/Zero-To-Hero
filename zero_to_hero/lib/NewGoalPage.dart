import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class NewGoalPage extends StatefulWidget {
  const NewGoalPage({Key? key}) : super(key: key);

  @override
  _NewGoalPageState createState() => _NewGoalPageState();
}

class _NewGoalPageState extends State<NewGoalPage> {
  final myController = TextEditingController();
  final remindController = TextEditingController();


  @override
  void dispose() {
    myController.dispose();
    remindController.dispose();
    super.dispose();
  }
  bool monR = false;
  bool tueR = false;
  bool wedR = false;
  bool thursR = false;
  bool friR = false;
  bool satR = false;
  bool sunR = false;

  Map<String, bool> reminders = {
  };

  final database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('New Goal Page'),
        )


        ,
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Container(
            child: Column(children: [
              TextField(controller: myController, minLines: 3,
                maxLines: 3,),
              Switch(

                value: monR,
                onChanged: (value) {
                  setState(() {
                    monR = value;
                  });
                },
              ),
              Switch(

                value: tueR,
                onChanged: (value) {
                  setState(() {
                    tueR = value;
                  });
                },
              ),
              Switch(

                value: wedR,
                onChanged: (value) {
                  setState(() {
                    wedR = value;
                  });
                },
              ),
              Switch(

                value: thursR,
                onChanged: (value) {
                  setState(() {
                    thursR = value;
                  });
                },
              ),
              Switch(

                value: friR,
                onChanged: (value) {
                  setState(() {
                    friR = value;
                  });
                },
              ),
              Switch(

                value: satR,
                onChanged: (value) {
                  setState(() {
                    satR = value;
                  });
                },
              ),
              Switch(

                value: sunR,
                onChanged: (value) {
                  setState(() {
                    sunR = value;
                  });
                },
              ),
              Text("When do you want Reminders?"),
              TextField(controller: remindController, minLines: 1,
                maxLines: 1,), TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  reminders[remindController.text] = false;
                  remindController.clear();
                },
                child: Text('Add'),
              )


          ]),

        ),
              ),
        ),



    floatingActionButton: FloatingActionButton(
       child: const Icon(Icons.add),
        onPressed: () {
         String descrip = myController.text;
          final newGoal = database.child('User/Goals/$descrip');
         newGoal.set({
            'Description': descrip,
           'Completed Today': false,
           'Days':{'Monday': monR, 'Tuesday': tueR,
             'Wednesday': wedR, 'Thursday': thursR,
             'Friday': friR, 'Saturday': satR, 'Sunday': sunR},
           'Reminders': reminders
         }
         );
        Navigator.pop(context);
       },
    ),



    );

  }
}

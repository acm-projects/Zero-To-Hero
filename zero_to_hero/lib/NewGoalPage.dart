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

  bool monR = false;
  bool tueR = false;
  bool wedR = false;
  bool thursR = false;
  bool friR = false;
  bool satR = false;
  bool sunR = false;

  void onChanged (bool value) {
    setState((){
      monR = value;
      tueR = value;
      wedR = value;
      thursR = value;
      friR = value;
      satR = value;
      sunR = value;
    });
  }

  final database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 133, 152, 199),
          title: const Text(
            'New Goal:',
            style: TextStyle(color: Colors.white),
          )
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Container(
            child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 20.0)),
              SizedBox(
                height: 30,
               // width: double.infinity,
                child: Container(
                  margin: const EdgeInsets.only(left: 0, top:0, right: 260, bottom:0),
                  child: const Text(
                    "Description:",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize:20,
                      color: Color.fromARGB(255, 116, 111, 109),
                    ),
                  ),
                ),
              ),

              TextField(controller: myController, minLines: 2,
                cursorColor:const Color.fromARGB(255, 56, 56, 56) ,
                style: const TextStyle(color: Color.fromARGB(255, 56, 56, 56)),
                decoration: const InputDecoration(
                    fillColor:  Color.fromARGB(255, 255, 224, 206), filled: true, focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 255, 224, 206)))),
                maxLines: 3,),
              SizedBox(
                 width: double.infinity,
                child: Container(
                  margin: const EdgeInsets.only(left: 0, top:40, right: 60, bottom:0),
                  child: const Text(
                    "What days of the week should you complete this goal?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize:20,
                      color: Color.fromARGB(255, 116, 111, 109),
                    ),
                  ),
                ),
              ),

                 // child: Row(
                 //
                 // ),
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor:Color.fromARGB(255, 255, 224, 206),
                    // fillColor: Color.fromARGB(255, 255, 224, 206),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    value: monR,
                    onChanged: (value) {
                      setState(() {
                        monR = value!;
                      });
                    },
                  ),

                  // child: Row(
                  //   children: [
                  //     Padding(padding: EdgeInsets.only(top: 20.0)),
                  //   ]
                  // ),


                  SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.only(left: 0, top:10, right: 60, bottom:0),
                  child: const Text(
                    "When do you want Reminders?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize:20,
                      color: Color.fromARGB(255, 116, 111, 109),
                    ),
                  ),
                ),
              ),

              Container(
                child: const Text(
                'Add new reminder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                color: const Color.fromARGB(255, 166, 189, 240),
                margin: const EdgeInsets.only(left: 0, top:20, right: 0, bottom:0),
                alignment: const AlignmentDirectional(0.0, 0.0),
                width: 500,
                height: 40,
              ),


              TextField(controller: remindController, minLines: 1,
                maxLines: 1,
              ),


 Container(
   margin: const EdgeInsets.only(top: 55.0),
   alignment: Alignment.bottomRight,
   child: TextButton(onPressed: (){
     print('I got clicked');
   },
       style: ButtonStyle(
         backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 166, 189, 240)),
         foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
         overlayColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 133, 152, 199)),
         minimumSize: MaterialStateProperty.all(const Size(240, 40)),
       ),

       child: const Text(
         'Create goal:',
         style: TextStyle(
           fontSize: 16,
         ),
       )
   ),
),
                ]),
        ),
          ),
        ),
    );




  }
}



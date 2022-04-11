import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'package:firebase_database/firebase_database.dart';
class SettingsPage extends StatefulWidget {
  final String uid;

  const SettingsPage({Key? key, required this.uid }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}
createAlertDialog(BuildContext context) {




  TextEditingController customController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want\n to logout?"),
          titleTextStyle: const TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 116, 111, 109)),
          actions: [
            MaterialButton(
              color: (
                  Colors.white
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
              ),
              child: const Text(" Cancel "),
              onPressed:  () {Navigator.of(context).pop();},
              textColor: const Color.fromARGB(255, 116, 111, 109),
            ),
            const Text("    "),

            MaterialButton(
              color: (const Color.fromARGB(255, 240, 139, 139)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: const Text("Logout"),
              textColor: Colors.white,
              onPressed:  () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginPage()
                )
                );
              },
            ),
            const Text("    "),
          ],
        );
      });
}

var goalStream;
var email;
bool notific = true;

class _SettingsPageState extends State<SettingsPage> {
  double _currentSliderValue1 = 3;
  double _currentSliderValue2 = 3;
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
        print(widget.uid);
        email = usersData['email'];
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 166, 189, 240),
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(

            children: [


              Column(
                children: [

                  Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color.fromARGB(255, 166, 189, 240), Color.fromARGB(255, 166, 189, 240)]
                            // colors: [Color.fromARGB(255, 166, 189, 240), Colors.white]
                          )
                      ),

                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              height: 50.0,
                            ),

                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                "https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg",
                              ),
                              radius: 60.0,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "User",
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),


                          ],


                        ),

                      )

                  ),




                ],
              ),
              Row(
                children: const [
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.center,
                  children:[Text('Email: $email')]),
              Row(
                children: const [
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),


              Row(children:[const Text('Days Before Bolded Goals'),
                Slider(
                  activeColor: const Color.fromARGB(255, 255, 224, 206),
                  thumbColor: const Color.fromARGB(255, 166, 189, 240),
                  value: _currentSliderValue1,
                  max: 4,
                  divisions: 4,
                  label: _currentSliderValue1.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue1 = value;
                    });
                  },
                ),]),
              Row(children:[const Text('Days Needed to Remove Bold'),
                Slider(
                  activeColor: const Color.fromARGB(255, 255, 224, 206),
                  thumbColor: const Color.fromARGB(255, 166, 189, 240),
                  value: _currentSliderValue2,
                  max: 4,
                  divisions: 4,
                  label: _currentSliderValue2.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue2 = value;
                    });
                  },
                ),]),

              // Text('Email: $email'),


              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50.0,
                  ),


                  const Text('Do you want to open the Notifications? ', textAlign: TextAlign.center,),
                  Transform.scale(
                    scale: 2,
                    child: Checkbox(
                      checkColor: Colors.white,
                      activeColor: const Color.fromARGB(255, 255, 224, 206),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0))),
                      side: const BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(255, 166, 189, 240)),
                      value: notific,
                      onChanged: (value) {
                        setState(() {
                          notific = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  SizedBox(
                    height: 90.0,
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: (){
                  createAlertDialog(context);
                },
                child: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 240, 139, 139),
                  onPrimary: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 17,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  minimumSize: const Size(370, 40),
                ),
              ),]

        ),
      ),

    );
  }
}

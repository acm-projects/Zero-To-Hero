import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'package:firebase_database/firebase_database.dart';
class SettingsPage extends StatefulWidget {
  final String uid;

  const SettingsPage({Key? key, required this.uid }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

Widget _buildPopupDialog(BuildContext context) {
  return  AlertDialog(
    title: const Text('Are you sure you want to logout?'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(
          primary: Colors.blue,
        ),
        child: const Text('Close'),
      ),
       TextButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const LoginPage()
          )
          );
        },
         style: TextButton.styleFrom(
           primary: Colors.red,
         ),
        child: const Text('Logout'),
      ),
    ],
  );
}

var goalStream;
var email;
bool notific = true;

class _SettingsPageState extends State<SettingsPage> {
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
      body: Column(
        children: [
           Text('Email: $email'),

        Row(
          children: [
            const Text('Notifications'),
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                checkColor: Colors.white,
                activeColor: const Color.fromARGB(255, 255, 224, 206),
                // fillColor: Color.fromARGB(255, 255, 224, 206),
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
          ElevatedButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(context),
              );
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
    );
  }
}

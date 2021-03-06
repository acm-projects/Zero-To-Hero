import 'package:flutter/material.dart';
import 'package:zero_to_hero/ChecklistPage.dart';//checklist page
import 'package:zero_to_hero/CalendarPage.dart';
import 'package:zero_to_hero/SettingsPage.dart';

class NavBar extends StatefulWidget {
  final String uid;

  NavBar({Key? key, required this.uid }) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}
class _NavBarState extends State<NavBar> {
  int selectedPage = 0; //New
  List<Widget> _pageOptions() => [
    ChecklistPage(uid: widget.uid),
    CalendarPage(uid: widget.uid),
    SettingsPage(uid: widget.uid)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavBar'),
      // ),
      body: _pageOptions()[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 166, 189, 240),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            label : 'Daily Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',

          )
        ],
        currentIndex: selectedPage,
        selectedItemColor: Colors.black,
        onTap: (index){
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  }
}
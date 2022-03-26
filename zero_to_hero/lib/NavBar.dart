import 'package:flutter/material.dart';
import 'package:zero_to_hero/ChecklistPage.dart';//checklist page
import 'package:zero_to_hero/CalendarPage.dart';
import 'package:zero_to_hero/SettingsPage.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}
class _NavBarState extends State<NavBar> {
  int selectedPage = 0; //New
  final _pageOptions = [
    ChecklistPage(),
    CalendarPage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavBar'),
      // ),
      body: _pageOptions[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 166, 189, 240),
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
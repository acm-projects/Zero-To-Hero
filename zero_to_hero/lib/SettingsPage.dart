import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
    backgroundColor: const Color.fromARGB(255, 166, 189, 240),
    title: const Text(
    'Settings Page',
    style: TextStyle(color: Colors.white),
    )),
    );
  }
}

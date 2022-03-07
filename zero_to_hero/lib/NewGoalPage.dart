import 'package:flutter/material.dart';
import 'package:zero_to_hero/ChecklistPage.dart';

class NewGoalPage extends StatefulWidget {
  const NewGoalPage({Key? key}) : super(key: key);

  @override
  _NewGoalPageState createState() => _NewGoalPageState();
}

class _NewGoalPageState extends State<NewGoalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Goal Page'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //go back to login screen
          Navigator.pop(context);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';


class AllGoalsPage extends StatefulWidget {
  const AllGoalsPage({Key? key}) : super(key: key);

  @override
  State<AllGoalsPage> createState() => _AllGoalsPageState();
}

class _AllGoalsPageState extends State<AllGoalsPage> {
  bool value= false;

  final goals = [
    Goal(title: 'Excersize for 30 minutes'),
    Goal(title: 'Water plants'),
    Goal(title: 'Cook dinner'),
    Goal(title: 'Drink 2 liters of water'),
  ];

  Widget buildSingleCheckbox(Goal goal) => ListTile(
      //controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        goal.title,
        style: const TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 116, 111, 109),
        ),
      ),
      trailing: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            //reroute to Edit Goal page here
          }
      )

  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'All Goals',
            style: TextStyle(
              color: Colors.white,
            )
        ),
        backgroundColor: const Color.fromARGB(255, 166, 189, 240),
      ),
      body: ListView (
        children: [
          ...goals.map(buildSingleCheckbox).toList(),



        ],
      ),





    );
  }
}

class Goal {
  final String title;
  bool isCompleted;

  Goal({
    required this.title,
    this.isCompleted = false,
  });
}
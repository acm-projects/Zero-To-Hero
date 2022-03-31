import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
              'Achievements',
              style: TextStyle(
                color: Colors.white,
              )
          ),
          backgroundColor: const Color.fromARGB(255, 166, 189, 240),
        ),

        body: SingleChildScrollView (
            padding: const EdgeInsets.all(15.0),
            child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget> [
                  SizedBox(height: 15),
                  Text (
                      'Statistics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      )
                  ),
                  SizedBox(height: 15),
                  Text (
                      'Total Goals Completed:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )
                  ),
                  Text (
                      '58/246',
                      style: TextStyle(
                        fontSize: 18,
                      )
                  ),
                  SizedBox(height: 12),
                  Text (
                      'Longest streak:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )
                  ),
                  Text (
                      '9 days',
                      style: TextStyle(
                        fontSize: 18,
                      )
                  ),
                  SizedBox(height: 12),
                  Text (
                      'Current Streak',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )
                  ),
                  Text (
                      '4 days',
                      style: TextStyle(
                        fontSize: 18,
                      )
                  ),


                ]
            )

        )
    );
  }
}

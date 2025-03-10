import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class MyPlansPage extends StatefulWidget {
  const MyPlansPage({super.key});

  @override
  _MyPlansPageState createState() => _MyPlansPageState();
}

class _MyPlansPageState extends State<MyPlansPage> {
  Map<String, dynamic>? dietPlan;

  @override
  void initState() {
    super.initState();
    loadDietPlan();
  }

  Future<void> loadDietPlan() async {
    final String response =
        await rootBundle.loadString('assets/diet_plan.json');
    final data = await json.decode(response);
    setState(() {
      dietPlan = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Diet Plan'),
      ),
      body: dietPlan == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dietPlan!.length,
              itemBuilder: (context, index) {
                String day = dietPlan!.keys.elementAt(index);
                List meals = dietPlan![day];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text(day),
                    children: meals.map<Widget>((meal) {
                      return ListTile(
                        title: Text(meal['meal']),
                        subtitle: Text(meal['description']),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}

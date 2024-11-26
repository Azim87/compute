import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(home: ComputeExamplePage());
}

class ComputeExamplePage extends StatefulWidget {
  const ComputeExamplePage({super.key});

  @override
  State<ComputeExamplePage> createState() => _ComputeExamplePageState();
}

class _ComputeExamplePageState extends State<ComputeExamplePage> {
  late List<People> peopleList;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    peopleList = [];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _parsePeopleJson,
          child: const Icon(Icons.abc),
        ),
        body: SafeArea(
          child: SizedBox(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: peopleList.length,
                    itemBuilder: (c, i) => ListTile(
                      title: Text(peopleList[i].name ?? ''),
                      subtitle: Text(peopleList[i].age.toString()),
                    ),
                  ),
          ),
        ),
      );

  Future<void> _parsePeopleJson() async {
    setState(() => loading = true);
    final ByteData jsonFile = await rootBundle.load('assets/people_500.json');
    final jsonString = utf8.decode(jsonFile.buffer.asUint8List());
    final List<People> peopleList = await compute(parsedJson, jsonString);
    setState(() {
      loading = false;
      this.peopleList = peopleList;
    });
  }

  static List<People> parsedJson(String jsonString) {
    final List<dynamic> parsed = jsonDecode(jsonString);
    return parsed.map((json) => People.fromJson(json)).toList();
  }
}

final class People {
  final String? name;
  final int? age;

  People({required this.name, required this.age});

  factory People.fromJson(Map<String, dynamic> json) {
    return People(
      name: json['name'],
      age: json['age'],
    );
  }
}

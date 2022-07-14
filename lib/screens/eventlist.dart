import 'package:aquest/screens/error_page.dart';
import 'package:flutter/material.dart';
import 'package:aquest/screens/functions.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
          },
          child: Text('data'))
      ),
    );
  }
}
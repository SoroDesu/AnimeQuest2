import 'package:flutter/material.dart';
import 'package:aquest/screens/functions.dart';

class AddQuestScreen extends StatefulWidget {
  const AddQuestScreen({Key? key}) : super(key: key);

  @override
  State<AddQuestScreen> createState() => _AddQuestScreenState();
}

class _AddQuestScreenState extends State<AddQuestScreen> {
  String _questName = '', _questDescription = '', _questAnswer = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Quest"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250.0,
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Quest Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _questName = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Quest Description',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _questDescription = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Quest Answer',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _questAnswer = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: () {
                      addNewQuest(_questName, _questDescription, _questAnswer);
                    },
                    child: Icon(Icons.add))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

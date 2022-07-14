import 'dart:convert';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:aquest/screens/functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aquest/screens/addquest.dart';

class QuestList extends StatefulWidget {
  const QuestList({Key? key}) : super(key: key);

  @override
  State<QuestList> createState() => _QuestListState();
}

class _QuestListState extends State<QuestList> {
  bool isAdmin = false;
  List<Widget> _questList = [];

  _updateQuestList() {
    getQuestList(context).then((value) {
      if (mounted) {
        setState(() {
          _questList = value;
        });
      }
    });
  }

  _updateAdmin() {
    if (mounted) {
      isUserAdmin().then((value) {
        if (mounted) {
          setState(() {
            isAdmin = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateAdmin();
    _updateQuestList();

    return Scaffold(
      appBar: isAdmin ? AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Quests"),
            IconButton(
                onPressed: () {
                  switchToAddQuestPage(context);
                },
                icon: const Icon(Icons.add)
            ),
          ],
        ),
        elevation: 0,
      ) : AppBar(
        title: Text("Quests"),
        elevation: 0,
      ),
      body: ListView(
        shrinkWrap: true,
        children: _questList,
      ),
    );
  }
}

Future getQuestList(BuildContext context) async {
  List<Container> widgets = [];
  String? questDescription = '';
  String? questName = '';
  String? questID = '';
  bool didComplete = false;

  final panelColor = Theme.of(context).colorScheme.surface;
  final datRef = FirebaseDatabase.instance.ref();
  final username = FirebaseAuth.instance.currentUser!.displayName;

  await datRef.child('quests').once().then((snapshot) async{
    for (var element in snapshot.snapshot.children) {
      didComplete = false;
      questID = element.key.toString();
      questName = element.child('name').value.toString();
      questDescription = element.child('description').value.toString();

      final compDatRef = FirebaseDatabase.instance.ref('usernames/$username/completed');

      // await compDatRef.child('completed').once().then((snapshot) {
      //   for (var elements in snapshot.snapshot.children) {
      //     if (elements.key.toString() == element.key.toString()) {
      //       didComplete = true;
      //     } else {
      //       didComplete = false;
      //     }
      //   }
      // });
      await compDatRef.child('$questID').once().then((snapshot) {
        if (snapshot.snapshot.exists) {
          didComplete = true;
        } else {
          didComplete = false;
        }
      });

      if (!didComplete) {
        widgets.add(
          Container(
            margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
            color: panelColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  hasIcon: true,
                ),
                header: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$questName",
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                collapsed: const Text(""),
                expanded: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "$questDescription",
                        textAlign: TextAlign.center,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            showQuestCompleteDialog(
                              context,
                              element.key,
                              element.child('answer').value.toString(),
                            );
                          },
                          child: Icon(Icons.check),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
      );
      }
    }
  });
  return widgets;
}

Future<void> showAlertDialog(BuildContext context, String text) async {
  return await showDialog(context: context, builder: (context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Text(text),
      );
    });
  });
}

Future<void> showQuestCompleteDialog(BuildContext context, String? questID, String questAnswer) async {
  return await showDialog(context: context, builder: (context) {
    return StatefulBuilder(builder: (context, setState) {
      String userAnswer = '';
      return AlertDialog(
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                textAlign: TextAlign.center,
                validator: (value) {
                  return value!.isNotEmpty ? null : 'Invalid Field';
                },
                decoration: InputDecoration(
                  hintText: 'Enter Quest Answer',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  userAnswer = value.trim();
                },
              ),
              TextButton(
              onPressed: () {
                if (userAnswer == '') {
                  showAlertDialog(context, 'You need to enter something...');
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.of(context).pop();
                  });
                } else if (userAnswer.toLowerCase() == questAnswer.toLowerCase()) {
                  showAlertDialog(context, 'Good Job!');
                  completeQuest(questID);
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                } else {
                  showAlertDialog(context, 'Wrong answer');
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.of(context).pop();
                  });
                }
              },
              child: const Text('Confirm')
              ),
            ],
          ),
        ),
      );
    });
  });
}

Future<bool?> completeQuest(String? questID) async {
  final username = FirebaseAuth.instance.currentUser!.displayName;
  final datRef = FirebaseDatabase.instance.ref('usernames/$username');
  int currentLevel = 0;

  await datRef.child('completed').update({
    questID.toString() : "",
  });

  final compDatRef = FirebaseDatabase.instance.ref('usernames/$username');
  await compDatRef.child('level').once().then((snapshot) {
    currentLevel = int.parse(snapshot.snapshot.value.toString());
    currentLevel++;
  });

  await datRef.update({
    'level' : '$currentLevel',
  });
}
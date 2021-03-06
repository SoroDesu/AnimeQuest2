import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aquest/screens/login.dart';
import 'package:aquest/classes/firebase_user.dart';

class CharacterSheet extends StatefulWidget {
  const CharacterSheet({Key? key}) : super(key: key);

  @override
  State<CharacterSheet> createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  final auth = FirebaseAuth.instance;
  static String _username = '';
  static String _level = '';
  static String _avatar = '';
  static String _title = '';

  Timer? timer;

  @override
  void initState() {
    updateUserInfo();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateUserInfo());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  updateUserInfo () {
    FirebaseUser().updateInfo();
    setState(() {
      // TODO: implement setState
      _username = FirebaseUser.username;
      _level = FirebaseUser.level;
      _avatar = FirebaseUser.avatar;
      _title = FirebaseUser.title;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Character Sheet"),
              IconButton(
                  onPressed: () {
                    auth.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LogInScreen()));
                  },
                  icon: const Icon(Icons.arrow_back)
              ),
            ],
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 100.0,
                      backgroundImage: NetworkImage(_avatar),
                    ),
                    Positioned(
                      left: 140,
                      child: FloatingActionButton(
                        child: Icon(Icons.edit),
                        onPressed: () {
                          FirebaseUser().uploadNewAvatar();
                          updateUserInfo();
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  _username,
                  style: const TextStyle(fontSize: 30.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Level",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          _level,
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Title",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          _title,
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}


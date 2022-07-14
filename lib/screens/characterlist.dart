import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aquest/screens/functions.dart';
import 'package:aquest/screens/login.dart';
import 'package:aquest/classes/firebase_user.dart';

class CharacterSheet extends StatefulWidget {
  const CharacterSheet({Key? key}) : super(key: key);

  @override
  State<CharacterSheet> createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  final auth = FirebaseAuth.instance;

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
                      backgroundImage: NetworkImage(FirebaseUser.avatar),
                    ),
                    Positioned(
                      left: 140,
                      child: FloatingActionButton(
                        child: Icon(Icons.edit),
                        onPressed: () {
                          uploadNewAvatar();
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  FirebaseUser.username,
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
                          FirebaseUser.level,
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
                          FirebaseUser.title,
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


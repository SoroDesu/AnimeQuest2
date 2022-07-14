import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aquest/screens/functions.dart';
import 'package:aquest/screens/login.dart';

class CharacterSheet extends StatefulWidget {
  const CharacterSheet({Key? key}) : super(key: key);

  @override
  State<CharacterSheet> createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  final auth = FirebaseAuth.instance;

  String _username = '';
  String _userLevel = '';
  String _userTitle = '';
  String _userAvatar = '';

  _updateUsername() {
    getUserName().then((value) {
      if (mounted) {
        setState(() {
          _username = value;
        });
      }
    });
  }

  _updateTitle() {
    getUserTitle().then((value) {
      if (mounted) {
        setState(() {
          _userTitle = value;
        });
      }
    });
  }

  _updateUserLevel() {
    getUserLevel().then((value) {
      if (mounted) {
        setState(() {
          _userLevel = value;
        });
      }
    });
  }

  _updateUserAvatar() {
    getUserAvatar().then((value) {
      if (mounted) {
        setState((){
          _userAvatar = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateUsername();
    _updateUserLevel();
    _updateTitle();
    _updateUserAvatar();

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
                      backgroundImage: NetworkImage(_userAvatar),
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
                          _userLevel,
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
                          _userTitle,
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


import 'package:aquest/screens/signup.dart';
import 'dart:io';
import 'package:aquest/screens/addquest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future sendVerificationEmail(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser!;
  try {
    await user.sendEmailVerification();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}

void switchToSignUpPage(BuildContext context) {
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignUpScreen()));
}

void switchToAddQuestPage(BuildContext context) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddQuestScreen()));
}

Future<bool> isUserAdmin() async{
  final auth = FirebaseAuth.instance;
  String isAdmin = '';

  String username = '';
  username = auth.currentUser!.displayName.toString();

  final datRef = FirebaseDatabase.instance.ref('usernames/$username');

  isAdmin = await datRef.child('admin').once().then((snapshot) => isAdmin = snapshot.snapshot.value.toString());

  if (isAdmin == null) {
    return false;
  }

  return isAdmin.parseBool();
}

extension BoolParsing on String {
  bool parseBool() {
    return this.toLowerCase() == 'true';
  }
}

Future addNewQuest(String questName, String questDescription, String questAnswer) async {
  int length;
  length = await FirebaseDatabase.instance.ref().child('quests').once().then((value) => length = value.snapshot.children.length);
  length++;
  try {
    final ref = FirebaseDatabase.instance.ref('quests/$length');

    await ref.update({
      'name' : questName,
      'description' : questDescription,
      'answer' : questAnswer,
    });

  } catch (e) {
    print(e.toString());
  }


}

prntPico() async {
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final uid = await _firebaseAuth.currentUser!.displayName.toString();
final datRef = FirebaseDatabase.instance.ref('usernames/$uid');
DatabaseEvent event = await datRef.once();

var userInfo = event.snapshot.value;

print(userInfo);
}
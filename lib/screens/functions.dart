import 'package:aquest/screens/signup.dart';
import 'dart:io';
import 'package:aquest/screens/addquest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> SignUpFun(String username, String email, String password) async {
  final auth = FirebaseAuth.instance;

  String avatarUrl = getDefaultAvatar();

  try {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    user?.updateDisplayName(username);

    final ref = FirebaseDatabase.instance.ref("usernames").push();

    user?.updateDisplayName(ref.key);

    await ref.set({
      "username": username,
      "level": 1,
      "title": "No Title",
      "avatar": avatarUrl,
      "completed" : ""
    });
  } catch (e) {
    print(e.toString());
  }
}

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

Future getUserName() async {
  final auth = FirebaseAuth.instance;

  String username = '';
  username = auth.currentUser!.displayName.toString();

  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('usernames/$username/username').get();

  String name = snapshot.value.toString();

  if (name != null) {
    return name;
  } else {
    return "Error: 727";
  }
}

Future<String> getUserTitle() async {
  final auth = FirebaseAuth.instance;

  String username = auth.currentUser!.displayName.toString();

  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('usernames/$username/title').get();

  String userTitle = snapshot.value.toString();

  if (userTitle != null) {
    return userTitle;
  } else {
    return "Error: 727";
  }
}

Future<String> getUserLevel() async {
  final auth = FirebaseAuth.instance;

  String username = '';
  username = auth.currentUser!.displayName.toString();

  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('usernames/$username/level').get();

  String userLevel = snapshot.value.toString();

  if (userLevel != null) {
    return userLevel;
  } else {
    return "Error: 727";
  }
}

Future<String> getUserAvatar() async {
  final auth = FirebaseAuth.instance;
  final datRef = FirebaseDatabase.instance.ref();

  String username = auth.currentUser!.displayName.toString();
  final snapshot = await datRef.child('usernames/$username/avatar').get();
  final avatarName = snapshot.value;
  final newUrl = "https://firebasestorage.googleapis.com/v0/b/animequest-94c00.appspot.com/o/avatars%2F$avatarName?alt=media&token=46f7f6f8-bd5d-44a6-941f-d3fd78624303";

  return newUrl;
}

String getDefaultAvatar() {
  var url = "https://firebasestorage.googleapis.com/v0/b/animequest-94c00.appspot.com/o/avatars%2Fdefault.jfif?alt=media&token=46f7f6f8-bd5d-44a6-941f-d3fd78624303";
  return url;
}

Future uploadNewAvatar() async {
  final auth = FirebaseAuth.instance;
  final storageRef = FirebaseStorage.instance.ref();
  final datRef = FirebaseDatabase.instance.ref();

  String username = auth.currentUser!.displayName.toString();

  final avatarStorageRef = storageRef.child('avatars/$username-avatar');

  final image = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (image == null) {
    return "no image selected";
  }

  File file = File(image.path);

  try {
    await avatarStorageRef.putFile(file);

    final snapshot = await datRef.child('usernames/$username');
    await snapshot.update({
      'avatar' : '$username-avatar',
    });

  } on FirebaseException catch (e) {
    return "oh noes, error in image";
  }
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
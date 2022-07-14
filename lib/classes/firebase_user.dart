import 'dart:io';

import 'package:aquest/screens/home.dart';
import 'package:aquest/screens/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aquest/screens/error_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseUser {
  static String username = 'default-user';
  static String level = '0';
  static String title = 'No Title';
  static String avatar = '';
  static String uid = '';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final datRef = FirebaseDatabase.instance.ref();

  Future<void> updateInfo () async {
    User? user = await _firebaseAuth.currentUser;
    username = user!.displayName.toString();
    uid = user.uid.toString();
    avatar = user.photoURL.toString();

    final _level = await datRef.child('usernames/$uid/level').get();
    level = _level.value.toString();

    final _title = await datRef.child('usernames/$uid/title').get();
    title = _title.value.toString();

  }

  Future<Widget> signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      uid = user!.uid;
      avatar = user.photoURL.toString();
      username = user.displayName.toString();

      final _level = await datRef.child('usernames/$uid/level').get();
      level = _level.value.toString();

      final _title = await datRef.child('usernames/$uid/title').get();
      title = _title.value.toString();

      return const HomeApp();

    } on FirebaseAuthException catch (e) {
      print(e);
      return ErrorPage(e.toString());
    } catch (e) {
      print(e);
      return ErrorPage(e.toString());
    }


  }

  Future<void> signUp({required BuildContext context, required String newusername, required String newemail,required String newpassword}) async {
    String avatarUrl = "https://firebasestorage.googleapis.com/v0/b/animequest-94c00.appspot.com/o/avatars%2Fdefault.jfif?alt=media&token=46f7f6f8-bd5d-44a6-941f-d3fd78624303?alt=media&token=46f7f6f8-bd5d-44a6-941f-d3fd78624303";

    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: newemail,
        password: newpassword
      );


      User? user = result.user;
      uid = user!.uid.toString();
      username = newusername;
      avatar = avatarUrl;

      user.updateDisplayName(newusername);
      user.updatePhotoURL(avatarUrl);

      final ref = FirebaseDatabase.instance.ref("usernames/$uid");

      await ref.update({
        "username": newusername,
        "level": level,
        "title": title,
        "avatar": avatarUrl,
        "completed" : ""
      });


      await user.sendEmailVerification();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerifyPage()));
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ErrorPage(e.toString())));
    } catch (e) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ErrorPage(e.toString())));
    }
  }

  Future uploadNewAvatar() async {
    final storageRef = FirebaseStorage.instance.ref();
    final datRef = FirebaseDatabase.instance.ref();
    final avatarUrl = 'https://firebasestorage.googleapis.com/v0/b/animequest-94c00.appspot.com/o/avatars%2F$uid-avatar?alt=media&token=46f7f6f8-bd5d-44a6-941f-d3fd78624303?alt=media&token=46f7f6f8-bd5d-44a6-941f-d3fd78624303';

    final avatarStorageRef = storageRef.child('avatars/$uid-avatar');

    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return "no image selected";
    }

    File file = File(image.path);

    try {
      await avatarStorageRef.putFile(file);

      final snapshot = await datRef.child('usernames/$uid');
      await snapshot.update({
        'avatar' : '$uid-avatar',
      });

      User? user = _firebaseAuth.currentUser;
      user!.updatePhotoURL(avatarUrl);
      FirebaseUser.avatar = '$uid-avatar';


    } on FirebaseException catch (e) {
      return e;
    }
  }
}
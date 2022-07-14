import 'package:aquest/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class FirebaseUser {
  static String username = 'default-user';
  static String level = '0';
  static String title = 'no-title';
  static String avatar = '';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final datRef = FirebaseDatabase.instance.ref();

  Future signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final uid = await _firebaseAuth.currentUser!.displayName.toString();

      final _username = await datRef.child('usernames/$uid/username').get();
      username = _username.value.toString();

      final _level = await datRef.child('usernames/$uid/level').get();
      level = _level.value.toString();

      final _title = await datRef.child('usernames/$uid/title').get();
      title = _title.value.toString();

      final _avatar = await datRef.child('usernames/$uid/avatar').get();
      final _avatarUrl = _avatar.value.toString();
      avatar = 'https://firebasestorage.googleapis.com/v0/b/animequest-94c00.appspot.com/o/avatars%2F$_avatarUrl?alt=media&token=46f7f6f8-bd5d-44a6-941f-d3fd78624303';

      return HomeApp();

    } on FirebaseAuthException catch (e) {
        print(e);
    } catch (e) {
      print(e);
    }
  }

  Future signUp({required String username, required String email,required String password}) async {
    final auth = FirebaseAuth.instance;

    String avatarUrl = "https://firebasestorage.googleapis.com/v0/b/animequest-94c00.appspot.com/o/avatars%2Fdefault.jfif?alt=media&token=46f7f6f8-bd5d-44a6-941f-d3fd78624303";

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
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e);
    }
  }
}
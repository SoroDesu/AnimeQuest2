import 'package:aquest/screens/app.dart';
import 'package:aquest/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({required String email, required password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return 'Signed in';
    } on FirebaseAuthException catch (e) {
        return e.message.toString();
    }

  }

  Future<String> signUp({required String email,required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return 'Signed up';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }

  }
}

class FirebaseUser {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return HomeApp();
    } catch (e) {
        print(e);
    }
  }
}
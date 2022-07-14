import 'dart:async';

import 'package:aquest/screens/functions.dart';
import 'package:aquest/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool _isVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // user needs to be create before verifying
    _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!_isVerified) {
      sendVerificationEmail(context);

      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    print(FirebaseAuth.instance.currentUser!.displayName);

    if (_isVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Widget build(BuildContext context) => _isVerified
      ? HomeApp()
      : Scaffold(
          appBar: AppBar(
            title: Text("Verify Email"),
          ),
        );
}

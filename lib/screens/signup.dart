import 'package:aquest/classes/firebase_user.dart';
import 'package:aquest/screens/functions.dart';
import 'package:aquest/screens/login.dart';
import 'package:aquest/screens/verify.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '', _password = '', _username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250.0,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: "Username",
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "This field is required";
                        }
                        if (value.contains("@")) {
                          return "Cannot contain special characters1";
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _username = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: "Email Address",
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "This field is required";
                        }
                        if (!value.contains("@")) {
                          return "This email is not valid";
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _email = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: "Password",
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "This field is required";
                        }
                        if (value.length < 6) {
                          return "Password has to be 6 characters or more";
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _password = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: 30.0),
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Processing Data...")));

                            FirebaseUser().signUp(username: _username, email: _email, password: _password);

                            Future.delayed(Duration(seconds: 4), () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const VerifyPage()));
                            });
                          }
                        },
                        child: Text("Sign Up")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LogInScreen()));
                        },
                        child: Text("Already have an account? Sign in"))
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

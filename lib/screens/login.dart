import 'package:aquest/screens/functions.dart';
import 'package:aquest/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aquest/classes/classes.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '', _password = '';
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In"),
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
                          borderRadius: BorderRadius.circular(10.0),
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
                    const SizedBox(height: 12.0),
                    TextFormField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
                    SizedBox(height: 20.0),
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Processing Data..."),
                              duration: Duration(seconds: 2),
                            ));

                            FirebaseUser user = new FirebaseUser();

                            if (auth.currentUser != null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Signing in..."),
                                duration: Duration(seconds: 2),
                              ));
                              Future.delayed(Duration(seconds: 4), () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => const HomeApp()));
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Incorrect email or password"),
                                duration: Duration(seconds: 1),
                              ));
                            }
                          }
                        },
                        child: Text("Sign In")),
                    TextButton(
                      onPressed: () {
                        switchToSignUpPage(context);
                      },
                      child: Text("Don't have an account? Sign up"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

import 'package:aquest/screens/login.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigoAccent,
        accentColor: Colors.indigoAccent,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigoAccent,
        accentColor: Colors.indigoAccent,
        brightness: Brightness.dark,
      ),
      home: LogInScreen(),
    );
  }
}

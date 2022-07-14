import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {

  String _errorText = '';

  ErrorPage(String errorText) {
    _errorText = errorText;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(_errorText),
      ),
    );
  }
}

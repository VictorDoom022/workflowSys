import 'package:flutter/material.dart';
import 'package:workflow_sys/view/loginPage.dart';

void main() {
  runApp(
      MaterialApp(
        initialRoute: '/',
        routes: {
          '/':(context) => loginPage(),
        },
      )
  );
}

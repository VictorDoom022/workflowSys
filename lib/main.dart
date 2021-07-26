import 'package:flutter/material.dart';
import 'package:workflow_sys/view/admin/adminHome.dart';
import 'package:workflow_sys/view/initLoading.dart';
import 'package:workflow_sys/view/loginPage.dart';

void main() {
  runApp(
      MaterialApp(
        initialRoute: '/',
        routes: {
          '/':(context) => initLoading(),
          '/login':(context) => loginPage(),
          '/adminHome':(context) => adminHome(),
        },
      )
  );
}

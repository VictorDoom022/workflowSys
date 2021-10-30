import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/view/admin/adminHome.dart';
import 'package:workflow_sys/view/initLoading.dart';
import 'package:workflow_sys/view/loginPage.dart';
import 'package:workflow_sys/view/user/userGroup.dart';
import 'package:workflow_sys/view/user/userHome.dart';

void main() {
  runApp(
      MaterialApp(
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          '/':(context) => initLoading(),
          '/login':(context) => loginPage(),
          '/adminHome':(context) => adminHome(),
          '/userHome':(context) => userHome(),
          '/userGroup':(context) => userGroup(),
        },
        theme: ThemeData(
          primaryColor: Color(0xfffbb448),
        ),
      )
  );
}

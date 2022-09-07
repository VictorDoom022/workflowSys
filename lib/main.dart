import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/view/admin/adminHome.dart';
import 'package:workflow_sys/view/initLoading.dart';
import 'package:workflow_sys/view/loginPage.dart';
import 'package:workflow_sys/view/user/desktopHomePage.dart';
import 'package:workflow_sys/view/user/userGroup.dart';
import 'package:workflow_sys/view/user/userDashboard.dart';

void main() {
  runApp(
      MaterialApp(
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          '/':(context) => initLoading(),
          '/login':(context) => loginPage(),
          '/adminHome':(context) => adminHome(),
          '/userHome':(context) => userDashboard(),
          '/userGroup':(context) => userGroup(),
          '/desktopHomePage':(context) => desktopHomePage()
        },
      )
  );
}

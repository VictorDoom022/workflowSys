import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/view/admin/adminHome.dart';
import 'package:workflow_sys/view/loginPage.dart';
import 'package:workflow_sys/view/user/userNavDrawer.dart';

class initLoading extends StatefulWidget {
  const initLoading({Key? key}) : super(key: key);

  @override
  _initLoadingState createState() => _initLoadingState();
}

class _initLoadingState extends State<initLoading> {

  int? userID;
  String? userPosition;
  String? userToken;

  @override
  void initState() {
    super.initState();

    getUserToken().then((value) => {
      if(value != null){
        getUserPosition().then((value) => {
          if(value == "admin"){
            Navigator.pushReplacementNamed(
              context,
              '/adminHome'
            )
          }else{
            if(Platform.isAndroid || Platform.isIOS){
              Navigator.pushReplacementNamed(
                  context,
                  '/userHome'
              )
            }else{
              Navigator.pushReplacementNamed(
                  context,
                  '/desktopHomePage'
              )
            }
          }
        })
      }else{
        SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacementNamed(
              context,
              '/login'
          );
        })
      }
    });
  }

  Future<String?> getUserToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("UserToken");
  }

  Future<String?> getUserPosition() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("UserPosition");
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(
            radius: 12,
          ),
        ),
      );
  }
}

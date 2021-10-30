import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/view/user/userNavDrawer.dart';

class userHome extends StatefulWidget {
  const userHome({Key? key}) : super(key: key);

  @override
  _userHomeState createState() => _userHomeState();
}

class _userHomeState extends State<userHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: userNavDrawer(),

    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class adminHome extends StatefulWidget {
  const adminHome({Key key}) : super(key: key);

  @override
  _adminHomeState createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Home'),
      ),
      body: Container(),
    );
  }
}

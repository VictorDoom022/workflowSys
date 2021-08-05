import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class createTask extends StatefulWidget {
  const createTask({Key key}) : super(key: key);

  @override
  _createTaskState createState() => _createTaskState();
}

class _createTaskState extends State<createTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('New Task'),
      ),
      body: Container(),
    );
  }
}

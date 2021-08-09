import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/view/user/userNavDrawer.dart';

class createTodo extends StatefulWidget {
  const createTodo({Key key}) : super(key: key);

  @override
  _createTodoState createState() => _createTodoState();
}

class _createTodoState extends State<createTodo> {

  GlobalKey<ScaffoldState> userCreateTodoScaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: userCreateTodoScaffoldKey,
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.list),
          onPressed: (){
            userCreateTodoScaffoldKey.currentState.openDrawer();
          },
        ),
        middle: Text('New Todo'),
      ),
      drawer: userNavDrawer(),
    );
  }
}

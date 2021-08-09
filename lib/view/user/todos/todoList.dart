import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../userNavDrawer.dart';

class todoList extends StatefulWidget {
  const todoList({Key key}) : super(key: key);

  @override
  _todoListState createState() => _todoListState();
}

class _todoListState extends State<todoList> {

  GlobalKey<ScaffoldState> userTodoListScaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: userTodoListScaffoldKey,
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.list),
          onPressed: (){
            userTodoListScaffoldKey.currentState.openDrawer();
          },
        ),
        middle: Text('Todo List'),
      ),
      drawer: userNavDrawer(),
    );
  }
}

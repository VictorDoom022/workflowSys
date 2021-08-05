import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/view/user/createTask.dart';

class taskListDetail extends StatefulWidget {

  final int taskListID;
  final String taskListUserName;

  const taskListDetail({Key key, this.taskListID, this.taskListUserName}) : super(key: key);

  @override
  _taskListDetailState createState() => _taskListDetailState(taskListID, taskListUserName);
}

class _taskListDetailState extends State<taskListDetail> {

  final int taskListID;
  final String taskListUserName;

  _taskListDetailState(this.taskListID, this.taskListUserName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(taskListUserName + '\'s Task List'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_){
                    return createTask(taskListID: taskListID);
              })
          );
        },
      ),
      body: Container(),
    );
  }
}

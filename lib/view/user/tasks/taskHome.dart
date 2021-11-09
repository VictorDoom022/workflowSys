import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:workflow_sys/model/UserReceiver.dart';
import 'package:workflow_sys/view/user/tasks/taskAssignedToUser.dart';
import 'package:workflow_sys/view/user/tasks/taskCompleted.dart';
import 'package:workflow_sys/view/user/tasks/taskListDetail.dart';

import 'createTask.dart';

class taskHome extends StatefulWidget {

  final UserReceiver userReceiver;
  final int teamID;
  final int taskListID;
  final String taskListUserName;
  final int taskListUserID;

  const taskHome({Key? key, required this.userReceiver, required this.teamID, required this.taskListID, required this.taskListUserID, required this.taskListUserName}) : super(key: key);

  @override
  _taskHomeState createState() => _taskHomeState(userReceiver, teamID, taskListID, taskListUserName, taskListUserID);
}

class _taskHomeState extends State<taskHome> {

  final UserReceiver userReceiver;
  final int teamID;
  final int taskListID;
  final String taskListUserName;
  final int taskListUserID;

  _taskHomeState(this.userReceiver, this.teamID, this.taskListID, this.taskListUserName, this.taskListUserID);

  Widget? currentWidget;
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCurrentUserTaskList();
    setState(() {
      currentWidget = screenList()[0];
    });
  }

  void checkCurrentUserTaskList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? userID = sharedPreferences.getInt("UserID");

    if(taskListUserID == userID){
      setState(() {
        itemList.insert(2, createTaskNavigationBarItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TitledBottomNavigationBar(
          items: itemList,
          currentIndex: _currentIndex,
          onTap: (selected){
            setState(() {
              _currentIndex = selected;
            });
          },
      ),
      body: screenList()[_currentIndex],
    );
  }

  TitledNavigationBarItem createTaskNavigationBarItem = TitledNavigationBarItem(
    icon: Icon(Icons.playlist_add),
    title: Text('Create Task'),
  );

  List<TitledNavigationBarItem> itemList = [
      TitledNavigationBarItem(
        icon: Icon(CupertinoIcons.square_list),
        title: Text('Task Created'),
      ),
      TitledNavigationBarItem(
        icon: Icon(CupertinoIcons.person_crop_circle_fill_badge_exclam),
        title: Text('Assigned To You'),
      ),
      TitledNavigationBarItem(
        icon: Icon(CupertinoIcons.checkmark_circle),
        title: Text('Completed Task'),
      ),
    ];

  List<Widget> screenList() {
    return [
      taskListDetail(userReceiver: userReceiver, teamID: teamID, taskListID: taskListID, taskListUserName: taskListUserName),
      taskAssigendToUser(userReceiver: userReceiver, teamID: teamID, taskListID: taskListID),
      createTask(teamID: teamID, taskListID: taskListID),
      taskCompleted(userReceiver: userReceiver, teamID: teamID, taskListID: taskListID),
    ];
  }

}

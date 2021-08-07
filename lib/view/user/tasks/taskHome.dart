import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:workflow_sys/model/UserReceiver.dart';
import 'package:workflow_sys/view/user/tasks/taskAssignedToUser.dart';
import 'package:workflow_sys/view/user/tasks/taskListDetail.dart';

import 'createTask.dart';

class taskHome extends StatefulWidget {

  final UserReceiver userReceiver;
  final int teamID;
  final int taskListID;
  final String taskListUserName;

  const taskHome({Key key, this.userReceiver, this.teamID, this.taskListID, this.taskListUserName}) : super(key: key);

  @override
  _taskHomeState createState() => _taskHomeState(userReceiver, teamID, taskListID, taskListUserName);
}

class _taskHomeState extends State<taskHome> {

  final UserReceiver userReceiver;
  final int teamID;
  final int taskListID;
  final String taskListUserName;

  _taskHomeState(this.userReceiver, this.teamID, this.taskListID, this.taskListUserName);

  Widget currentWidget;
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      currentWidget = screenList()[0];
    });
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

  List<TitledNavigationBarItem> itemList = [
      TitledNavigationBarItem(
        icon: CupertinoIcons.square_list,
        title: Text('Task Created'),
      ),
      TitledNavigationBarItem(
        icon: CupertinoIcons.person_crop_circle_fill_badge_exclam,
        title: Text('Assigned To You'),
      ),
      TitledNavigationBarItem(
        icon: CupertinoIcons.text_badge_plus,
        title: Text('Create Task'),
      ),
    ];

  List<Widget> screenList() {
    return [
      taskListDetail(userReceiver: userReceiver, teamID: teamID, taskListID: taskListID, taskListUserName: taskListUserName),
      taskAssigendToUser(userReceiver: userReceiver, teamID: teamID, taskListID: taskListID),
      createTask(teamID: teamID, taskListID: taskListID),
    ];
  }

}

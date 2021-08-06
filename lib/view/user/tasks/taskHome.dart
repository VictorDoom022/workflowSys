import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:workflow_sys/view/user/tasks/taskListDetail.dart';

import 'createTask.dart';

class taskHome extends StatefulWidget {

  final int teamID;
  final int taskListID;
  final String taskListUserName;

  const taskHome({Key key, this.teamID, this.taskListID, this.taskListUserName}) : super(key: key);

  @override
  _taskHomeState createState() => _taskHomeState(teamID, taskListID, taskListUserName);
}

class _taskHomeState extends State<taskHome> {

  final int teamID;
  final int taskListID;
  final String taskListUserName;

  _taskHomeState(this.teamID, this.taskListID, this.taskListUserName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(),
      body: PersistentTabView(
          context,
          items: itemList(),
          screens: screenList()
      ),
    );
  }

  List<PersistentBottomNavBarItem> itemList(){
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.square_list),
        title: 'Task Created',
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.text_badge_plus),
        title: 'Create Task',
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<Widget> screenList() {
    return [
      taskListDetail(teamID: teamID, taskListID: taskListID, taskListUserName: taskListUserName),
      createTask(taskListID: taskListID),
    ];
  }

}

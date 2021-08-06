import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/model/Task.dart';
import 'package:workflow_sys/view/initLoading.dart';
import 'package:workflow_sys/view/user/tasks/taskListDetail.dart';

class taskAssigendToUser extends StatefulWidget {

  final int teamID;
  final int taskListID;

  const taskAssigendToUser({Key key, this.teamID, this.taskListID}) : super(key: key);

  @override
  _taskAssigendToUserState createState() => _taskAssigendToUserState(teamID, taskListID);
}

class _taskAssigendToUserState extends State<taskAssigendToUser> {

  final int teamID;
  final int taskListID;

  _taskAssigendToUserState(this.teamID, this.taskListID);

  RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<List<Task>> futureTaskAssignedList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getTaskAssignedData();
    });
  }

  Future<void> getTaskAssignedData() async {
    List<Task> taskList = await getTaskAssignedToUser(taskListID);
    setState(() {
      futureTaskAssignedList = Future.value(taskList);
    });
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Task Assigned To You'),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        header: BezierCircleHeader(),
        onRefresh: getTaskAssignedData,
        child: FutureBuilder<List<Task>>(
          future: futureTaskAssignedList,
          builder: (context, snapshot){
            if(snapshot.hasError) print(snapshot.error);

            if(snapshot.hasData){
              if(snapshot.data.toString() != "[]"){
                return taskItem(teamID: teamID, listTask: snapshot.data);
              }else{
                return Center(child: Text('No task created'));
              }
            }else{
              return Center(child: CupertinoActivityIndicator(radius: 12));
            }
          },
        ),
      ),
    );
  }
}

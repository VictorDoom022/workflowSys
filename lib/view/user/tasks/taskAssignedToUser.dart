import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/model/Task.dart';
import 'package:workflow_sys/model/UserReceiver.dart';
import 'package:workflow_sys/view/initLoading.dart';
import 'package:workflow_sys/view/user/tasks/taskListDetail.dart';

class taskAssigendToUser extends StatefulWidget {

  final UserReceiver userReceiver;
  final int teamID;
  final int taskListID;

  const taskAssigendToUser({Key key, this.userReceiver, this.teamID, this.taskListID}) : super(key: key);

  @override
  _taskAssigendToUserState createState() => _taskAssigendToUserState(userReceiver, teamID, taskListID);
}

class _taskAssigendToUserState extends State<taskAssigendToUser> {

  final UserReceiver userReceiver;
  final int teamID;
  final int taskListID;

  _taskAssigendToUserState(this.userReceiver, this.teamID, this.taskListID);

  RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<List<Task>> futureTaskAssignedList;
  String searchKeyWord="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaskAssignedData();
  }

  Future<void> getTaskAssignedData() async {
    List<Task> taskList = await getTaskAssignedToUser(taskListID);
    setState(() {
      futureTaskAssignedList = Future.value(taskList);
    });
    refreshController.refreshCompleted();
  }

  Future<List<Task>> searchList() async {
    List<Task> listTask = await futureTaskAssignedList;
    List<Task> searchList = [];

    if(searchKeyWord == ""){
      searchList = listTask;
    }else {
      for(int i=0; i < listTask.length; i++){
        if(listTask[i].taskName.toLowerCase().contains(searchKeyWord.toLowerCase()) == true){
          searchList.add(listTask[i]);
        }
      }
    }

    return searchList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Task Assigned To You'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(
              onChanged: (value){
                setState(() {
                  searchKeyWord = value;
                });
                searchList();
              },
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: refreshController,
              enablePullDown: true,
              header: BezierCircleHeader(),
              onRefresh: getTaskAssignedData,
              child: FutureBuilder<List<Task>>(
                future: searchKeyWord=="" ? futureTaskAssignedList : searchList(),
                builder: (context, snapshot){
                  if(snapshot.hasError) print(snapshot.error);

                  if(snapshot.hasData){
                    if(snapshot.data.toString() != "[]"){
                      return taskItem(userReceiver: userReceiver, teamID: teamID, listTask: snapshot.data);
                    }else{
                      return Center(child: Text('No task created'));
                    }
                  }else{
                    return Center(child: CupertinoActivityIndicator(radius: 12));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
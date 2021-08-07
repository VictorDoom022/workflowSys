import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/model/Task.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserReceiver.dart';
import 'package:workflow_sys/view/user/tasks/createTask.dart';
import 'package:workflow_sys/view/user/tasks/taskDetail.dart';

class taskListDetail extends StatefulWidget {

  final UserReceiver userReceiver;
  final int teamID;
  final int taskListID;
  final String taskListUserName;

  const taskListDetail({Key key, this.userReceiver, this.teamID, this.taskListID, this.taskListUserName}) : super(key: key);

  @override
  _taskListDetailState createState() => _taskListDetailState(userReceiver, teamID, taskListID, taskListUserName);
}

class _taskListDetailState extends State<taskListDetail> {

  final UserReceiver userReceiver;
  final int teamID;
  final int taskListID;
  final String taskListUserName;

  _taskListDetailState(this.userReceiver, this.teamID, this.taskListID, this.taskListUserName);

  RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<List<Task>> futureTaskList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaskData();
  }

  Future<void> getTaskData() async {
    List<Task> taskList = await getTaskByTaskListID(taskListID);
    setState(() {
      futureTaskList = Future.value(taskList);
    });
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(taskListUserName + '\'s Task List'),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        header: BezierCircleHeader(),
        onRefresh: getTaskData,
        child: FutureBuilder<List<Task>>(
          future: futureTaskList,
          builder: (context, snapshot){
            if(snapshot.hasError) print(snapshot.error);

            if(snapshot.hasData){
              if(snapshot.data.toString() != "[]"){
                return taskItem(userReceiver: userReceiver, teamID: teamID,listTask: snapshot.data);
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

class taskItem extends StatelessWidget {

  final UserReceiver userReceiver;
  final int teamID;
  final List<Task> listTask;

  const taskItem({Key key, this.userReceiver, this.teamID, this.listTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listTask.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(listTask[index].taskName),
          trailing: Text('Assigned to: ' + checkLastAssignedUser(listTask[index].taskAssignedMemberID)),
          subtitle: Text('Last updated: ' + convertBackendDateTime(listTask[index].updatedAt)),
          onTap: (){
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder:(context){
                      return taskDetail(teamID: teamID, taskID: listTask[index].id);
                    }
                )
            );
          },
        );
      },
    );
  }

  String checkLastAssignedUser(String taskAssignedMemberList) {
    List<User> userList = userReceiver.user;
    List<String> assignedMemberList = taskAssignedMemberList.split(',');
    for(int i=0; i < userList.length; i++){
      if(assignedMemberList.last == userList[i].id.toString()){
          return userList[i].name;
      }
    }
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/model/Task.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserReceiver.dart';
import 'package:workflow_sys/view/misc/TaskCard.dart';
import 'package:workflow_sys/view/user/tasks/taskDetail.dart';
import 'package:workflow_sys/view/user/tasks/taskListDetail.dart';

class taskCompleted extends StatefulWidget {

  final UserReceiver userReceiver;
  final int teamID;
  final int taskListID;

  const taskCompleted({Key? key, required this.userReceiver, required this.teamID, required this.taskListID}) : super(key: key);

  @override
  _taskCompletedState createState() => _taskCompletedState(userReceiver, teamID, taskListID);
}

class _taskCompletedState extends State<taskCompleted> {

  final UserReceiver userReceiver;
  final int teamID;
  final int taskListID;

  _taskCompletedState(this.userReceiver, this.teamID, this.taskListID);

  RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<List<Task>>? futureTaskAssignedList;
  String searchKeyWord="";
  String dropDownSortValue = "Default";
  List<String> dropDownListSelections = ['Default', 'Create At Desc', 'Updated Asc', 'Updated Desc', 'Name Asc', 'Name Desc', 'Priority Asc', 'Priority Desc', 'Color Asc', 'Color Desc'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaskCompletedData();
  }

  Future<void> getTaskCompletedData() async {
    List<Task> taskList = await getCompletedTaskByTaskListID(taskListID);
    // createAt asc (default)
    taskList.sort((a,b) => a.createdAt!.compareTo(b.createdAt!));

    setState(() {
      futureTaskAssignedList = Future.value(taskList);
    });
    refreshController.refreshCompleted();
  }

  void sortList(String sortType) async {
    List<Task>? listTask = await futureTaskAssignedList;

    if(sortType == dropDownListSelections[0]){
      listTask!.sort((a,b) => a.createdAt!.compareTo(b.createdAt!));
    }else if(sortType == dropDownListSelections[1]){
      listTask!.sort((a,b) => b.createdAt!.compareTo(a.createdAt!));
    }else if(sortType == dropDownListSelections[2]){
      listTask!.sort((a,b) => a.updatedAt!.compareTo(b.updatedAt!));
    }else if(sortType == dropDownListSelections[3]){
      listTask!.sort((a,b) => b.updatedAt!.compareTo(a.updatedAt!));
    }else if(sortType == dropDownListSelections[4]){
      listTask!.sort((a,b) => a.taskName!.compareTo(b.taskName!));
    }else if(sortType == dropDownListSelections[5]){
      listTask!.sort((a,b) => b.taskName!.compareTo(a.taskName!));
    }else if(sortType == dropDownListSelections[6]){
      listTask!.sort((a,b) => a.taskPriority!.compareTo(b.taskPriority!));
    }else if(sortType == dropDownListSelections[7]){
      listTask!.sort((a,b) => b.taskPriority!.compareTo(a.taskPriority!));
    }else if(sortType == dropDownListSelections[8]){
      listTask!.sort((a,b) => a.taskColor!.compareTo(b.taskColor!));
    }else if(sortType == dropDownListSelections[9]){
      listTask!.sort((a,b) => b.taskColor!.compareTo(a.taskColor!));
    }

    setState(() {
      futureTaskAssignedList = Future.value(listTask);
    });
  }

  Future<List<Task>> searchList() async {
    List<Task>? listTask = await futureTaskAssignedList;
    List<Task> searchList = [];

    if(searchKeyWord == ""){
      searchList = listTask!;
    }else {
      for(int i=0; i < listTask!.length; i++){
        if(listTask[i].taskName!.toLowerCase().contains(searchKeyWord.toLowerCase()) == true){
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
        middle: Text('Completed Task'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 12,
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
                  flex: 4,
                  child: Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          icon: Icon(Icons.filter_list),
                          elevation: 0,
                          value: dropDownSortValue,
                          style: TextStyle(
                              color: Colors.black,
                              overflow: TextOverflow.fade
                          ),
                          items: dropDownListSelections.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue){
                            sortList(newValue.toString());
                            setState(() {
                              dropDownSortValue = newValue.toString();
                            });
                          },
                        ),
                      )
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: refreshController,
              enablePullDown: true,
              header: ClassicHeader(),
              onRefresh: getTaskCompletedData,
              child: FutureBuilder<List<Task>>(
                future: searchKeyWord=="" ? futureTaskAssignedList : searchList(),
                builder: (context, snapshot){
                  if(snapshot.hasError) print(snapshot.error);

                  if(snapshot.hasData){
                    if(snapshot.data.toString() != "[]"){
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: GestureDetector(
                              child:
                              TaskCard(
                                taskDate: convertBackendDateTimeToDate(snapshot.data![index].createdAt!),
                                taskMonth: convertBackendDateTimeToMonth(snapshot.data![index].createdAt!),
                                title: snapshot.data![index].taskName!,
                                taskCreateUserName: checkLastAssignedUser(snapshot.data![index].taskUserCreateID!)!,
                                lastUpdatedTime: convertBackendDateTime(snapshot.data![index].updatedAt),
                                lastAssignedUserName: checkLastAssignedUser(snapshot.data![index].taskAssignedMemberID!)!,
                                statusMsg: snapshot.data![index].taskStatusMsg!,
                                desc: snapshot.data![index].taskDesc!,
                                color: snapshot.data![index].taskColor!,
                                priority: snapshot.data![index].taskPriority!,
                              ),
                              onTap: (){
                                HapticFeedback.lightImpact();
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder:(context){
                                          return taskDetail(teamID: teamID, taskID: snapshot.data![index].id!);
                                        }
                                    )
                                ).then((value) {
                                  getTaskCompletedData();
                                });
                              },
                            ),
                          );
                        },
                      );
                    }else{
                      return Center(child: Text('No task completed'));
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

  String? checkLastAssignedUser(String taskAssignedMemberList) {
    List<User?>? userList = userReceiver.user;
    List<String> assignedMemberList = taskAssignedMemberList.split(',');

    if(taskAssignedMemberList.length !=0){
      for(int i=0; i < userList!.length; i++){
        if(assignedMemberList.last == userList[i]!.id.toString()){
          return userList[i]!.name;
        }
      }
    }else{
      return 'Not assigned';
    }
  }
}

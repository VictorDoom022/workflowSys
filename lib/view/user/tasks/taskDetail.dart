import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/model/Task.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/selectors/selectMember.dart';
import 'package:workflow_sys/view/user/tasks/taskAssignedHistory.dart';

class taskDetail extends StatefulWidget {

  final int teamID;
  final int taskID;

  const taskDetail({Key key, this.teamID, this.taskID}) : super(key: key);

  @override
  _taskDetailState createState() => _taskDetailState(teamID, taskID);
}

class _taskDetailState extends State<taskDetail> {

  final int teamID;
  final int taskID;

  _taskDetailState(this.teamID, this.taskID);

  GlobalKey<ScaffoldState> editTaskScaffoldKey = GlobalKey();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescController = TextEditingController();
  TextEditingController taskStatusMsgController = TextEditingController();

  String lastAssignedUserName = "Not Assigned";
  int taskStatus;
  DateTime taskStartDate, taskDueDate;
  String taskAssignedDate;
  List<String> taskAssignedUserIDList;
  bool allowUserEdit = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaskByID(context, taskID).then((value) {
      taskNameController.text = value.taskName;
      taskDescController.text = value.taskDesc;
      taskStatusMsgController.text = value.taskStatusMsg;

      if(value.taskStartDate != "null"){
        setState(() {
          taskStartDate = convertStringToDateTime(value.taskStartDate);
        });
      }

      if(value.taskDueDate != "null"){
        setState(() {
          taskDueDate = convertStringToDateTime(value.taskDueDate);
        });
      }

      setState(() {
        taskAssignedDate = value.taskAssignedDate;
      });

      checkToAllowEdit(value);
      checkTaskStatus(value);
    });
  }

  void checkToAllowEdit(Task task) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int userID = sharedPreferences.getInt("UserID");
    List<String> assignedUserID = task.taskAssignedMemberID.split(',');

    setState(() {
      taskAssignedUserIDList = assignedUserID;
    });

    checkLastAssignedUser(assignedUserID);

    bool taskCreator = false;
    bool taskAssignedUser = false;

    // check if the task creator is the current user
    if(userID.toString() == task.taskUserCreateID){
     taskCreator = true;
    }

    // check if current user is being assigned to this task
    for(int j=0; j < assignedUserID.length; j++){
      if(assignedUserID[j] == userID.toString()){
        taskAssignedUser = true;
      }
    }

    // determine if user can edit or not
    if(taskCreator || taskAssignedUser){
      setState(() {
        allowUserEdit = true;
      });
    }else{
      setState(() {
        allowUserEdit = false;
      });
    }
  }

  void checkTaskStatus(Task task) {
    setState(() {
      taskStatus = task.taskStatus;
    });
  }

  Future<List<User>> getUserJoinedTeamList() async {
    List<User> userList = await getUserJoinedTeam(teamID);

    return userList;
  }

  Future<void> checkLastAssignedUser(List<String> assignedUserList) async {
    List<User> userList = await getUserJoinedTeam(teamID);
    for(int i=0; i < userList.length; i++){
      if(assignedUserList.last == userList[i].id.toString()){
        setState(() {
          lastAssignedUserName = userList[i].name;
        });
      }
    }
  }

  InputDecoration textFieldInputDecoration = InputDecoration(
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('Edit Task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Task basic info',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Task Name'),
                            ),
                            Expanded(
                              flex: 9,
                              child: TextField(
                                enabled: allowUserEdit,
                                controller: taskNameController,
                                decoration: textFieldInputDecoration,
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Task Description'),
                            ),
                            Expanded(
                              flex: 9,
                              child: TextField(
                                enabled: allowUserEdit,
                                controller: taskDescController,
                                maxLines: 5,
                                decoration: textFieldInputDecoration,
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Task Status'),
                            ),
                            Expanded(
                              flex: 9,
                              child: TextField(
                                enabled: allowUserEdit,
                                controller: taskStatusMsgController,
                                maxLines: 1,
                                minLines: 1,
                                decoration: textFieldInputDecoration,
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Assigned member'),
                            ),
                            Expanded(
                              flex: 9,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: TextButton(
                                      child: Text(lastAssignedUserName=='Not Assigned' ? 'Click to assign': lastAssignedUserName),
                                      onPressed: allowUserEdit == true ? () {
                                        getUserJoinedTeamList().then((value) {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(builder: (_){
                                                return selectMember(type: 6, teamID: taskID, userList: value);
                                              })
                                          );
                                        });
                                      } : null,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                      child: TextButton(
                                        child: Text(
                                            lastAssignedUserName=='Not Assigned' ? 'No history' : 'View assign history'
                                        ),
                                        onPressed:  lastAssignedUserName!='Not Assigned' ? () {
                                          getUserJoinedTeamList().then((value) {
                                            List<String> assignDateList = taskAssignedDate.split(',');
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(builder: (_){
                                                  return taskAssignedHistory(userList: value, assignedUserList: taskAssignedUserIDList, assignedDateList: assignDateList);
                                                })
                                            );
                                          });
                                        } : null,
                                      )
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Extras',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Start Date'),
                            ),
                            Expanded(
                                flex: 9,
                                child: TextButton(
                                  child: Text(taskStartDate==null ? 'Select date' : taskStartDate.toString()),
                                  onPressed: allowUserEdit==true ? (){
                                    showDialog(
                                        context: context,
                                        builder: (_){
                                          return Dialog(
                                            child: SfDateRangePicker(
                                              showActionButtons: true,
                                              initialDisplayDate: taskStartDate,
                                              initialSelectedDate: taskStartDate,
                                              onSubmit: (date){
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  taskStartDate = date;
                                                });
                                              },
                                              onCancel: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          );
                                        }
                                    );
                                  } : null,
                                )
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Due Date'),
                            ),
                            Expanded(
                              flex: 9,
                              child: TextButton(
                                child: Text(taskDueDate==null ? 'Select date' : taskDueDate.toString()),
                                onPressed: allowUserEdit==true ? (){
                                  showDialog(
                                      context: context,
                                      builder: (_){
                                        return Dialog(
                                          child: SfDateRangePicker(
                                            showActionButtons: true,
                                            initialDisplayDate: taskDueDate,
                                            initialSelectedDate: taskDueDate,
                                            onSubmit: (date){
                                              Navigator.of(context).pop();
                                              setState(() {
                                                taskDueDate = date;
                                              });
                                            },
                                            onCancel: (){
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        );
                                      }
                                  );
                                } : null,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        taskStatus==1 ? 'Mark task as complete' : 'Re-activate task',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.amber
                          )
                      ),
                      onPressed: allowUserEdit == true ? () {
                        LoadingScreen.showLoadingScreen(context, editTaskScaffoldKey);

                        changeTaskStatus(context, taskID, taskStatus).then((value) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        });
                      } : null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        'Delete',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red
                          )
                      ),
                      onPressed: allowUserEdit == true ? () {
                        showCupertinoDialog(
                            context: context,
                            builder: (_){
                              return CupertinoAlertDialog(
                                content: Text(
                                  'Are you sure you want to delete this task?',
                                  style: TextStyle(
                                      fontSize: 20
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: (){
                                      HapticFeedback.lightImpact();
                                      Navigator.of(
                                          context,
                                          rootNavigator: true
                                      ).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          color: Colors.blue
                                      ),
                                    ),
                                    onPressed: () {
                                      LoadingScreen.showLoadingScreen(context, editTaskScaffoldKey);
                                      deleteTask(context, taskID).then((value) {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  )
                                ],
                              );
                            }
                        );
                      } : null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.amber
                          )
                      ),
                      onPressed: allowUserEdit==true ? () {
                        if(taskNameController.text.isNotEmpty && taskDescController.text.isNotEmpty && taskStatusMsgController.text.isNotEmpty){
                          LoadingScreen.showLoadingScreen(context, editTaskScaffoldKey);

                          String startDate = taskStartDate.toString();
                          String dueDate = taskDueDate.toString();

                          updateTask(context, taskID, taskNameController.text, taskDescController.text, taskStatusMsgController.text, startDate, dueDate).then((value) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          });
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name, description & status cannot be empty')));
                        }
                      } : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

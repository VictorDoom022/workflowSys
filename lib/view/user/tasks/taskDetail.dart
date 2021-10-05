import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/model/FileReceiver.dart';
import 'package:workflow_sys/model/Task.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/view/misc/TaskForm.dart';
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

  String taskDetailedDesc = '';
  String lastAssignedUserName = "Not Assigned";
  int taskStatus;
  DateTime taskStartDate, taskDueDate;
  String taskAssignedDate;
  List<String> taskAssignedUserIDList;
  bool allowUserEdit = true;
  List<String> attachedFilePaths = [];
  List<FileReceiver> taskFileReceiver = [];
  String taskFilePath = '';

  List<String> colorList = ['Default', 'Blue', 'Red', 'Yellow', 'Green', 'Grey', 'Black'];
  List<String> priorityList = ['Very Low', 'Low', 'Medium (Default)', 'High', 'Very High'];
  String selectedColor;
  String selectedPriority;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaskData();
  }

  void getTaskData(){
    getTaskByID(context, taskID).then((value) {
      taskNameController.text = value.taskName;
      taskDescController.text = value.taskDesc;
      taskStatusMsgController.text = value.taskStatusMsg;
      taskDetailedDesc = value.taskDetailedDesc;
      taskFilePath = value.taskFilePath;

      if(taskFilePath != null){
        setTaskFileData();
      }

      setState(() {
        selectedColor = colorList[value.taskColor];
        selectedPriority = priorityList[value.taskPriority];
      });

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

  void setTaskFileData() async {
    List<FileReceiver> fileReceiverList = await fetchTaskFiles(taskFilePath);
    setState(() {
      taskFileReceiver = fileReceiverList;
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
                TaskFormCard(
                  cardTitle: 'Task basic info',
                  cardItemList: [
                    TaskItem(
                      itemTitle: 'Task Name',
                      itemWidget: TextField(
                        enabled: allowUserEdit,
                        controller: taskNameController,
                        decoration: textFieldInputDecoration,
                      ),
                    ),
                    Divider(),
                    TaskItem(
                      itemTitle: 'Color',
                      itemWidget: DropdownButton<String>(
                        value: selectedColor,
                        isExpanded: true,
                        items: colorList.map((e){
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (selectedItem){
                          setState(() {
                            selectedColor = selectedItem;
                          });
                        },
                      ),
                    ),
                    Divider(),
                    TaskItem(
                      itemTitle: 'Priority',
                      itemWidget: DropdownButton<String>(
                        value: selectedPriority,
                        isExpanded: true,
                        items: priorityList.map((e){
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (selectedItem){
                          setState(() {
                            selectedPriority = selectedItem;
                          });
                        },
                      ),
                    ),
                    Divider(),
                    TaskItem(
                      itemTitle: 'Task Description',
                      itemWidget: TextField(
                        enabled: allowUserEdit,
                        controller: taskDescController,
                        maxLines: 10,
                        decoration: textFieldInputDecoration,
                      ),
                    ),
                    Divider(),
                    taskDetailedDesc != null ? TaskItem(
                      itemTitle: 'Task Detailed Description (Read-only)',
                      itemWidget: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 10,
                          maxHeight: 250,
                          minWidth: double.infinity,
                        ),
                        child: SingleChildScrollView(
                          child: Html(
                            data: taskDetailedDesc,
                              style: {
                                // tables will have the below background color
                                "table": Style(
                                  backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                ),
                                // some other granular customizations are also possible
                                "tr": Style(
                                  border: Border(bottom: BorderSide(color: Colors.grey)),
                                ),
                                "th": Style(
                                  padding: EdgeInsets.all(6),
                                  backgroundColor: Colors.grey,
                                ),
                                "td": Style(
                                  padding: EdgeInsets.all(6),
                                  alignment: Alignment.topLeft,
                                ),
                                // text that renders h1 elements will be red
                                "h1": Style(color: Colors.red),
                              }
                          ),
                        ),
                      ),
                    ) : Container(),
                    taskDetailedDesc != null ? Divider() : Container(),
                    TaskItem(
                      itemTitle: 'Task Status',
                      itemWidget: TextField(
                        enabled: allowUserEdit,
                        controller: taskStatusMsgController,
                        maxLines: 1,
                        minLines: 1,
                        decoration: textFieldInputDecoration,
                      ),
                    ),
                    Divider(),
                    TaskItem(
                      itemTitle: 'Attach Files',
                      itemWidget: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: TextButton(
                              child: Text('Select File'),
                              onPressed: () async {
                                FilePickerResult filePickerResult = await FilePicker.platform.pickFiles(
                                    allowMultiple: true
                                );

                                if(filePickerResult != null){
                                  List<File> fileList = filePickerResult.paths.map((e) => File(e)).toList();
                                  for(int i=0; i<fileList.length; i++){
                                    setState(() {
                                      attachedFilePaths.add(fileList[i].path);
                                    });
                                  }
                                }else{
                                  setState(() {
                                    attachedFilePaths = [];
                                  });
                                }
                              },
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Text('Attached Files (' + attachedFilePaths.length.toString() + ')'),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    taskFilePath != null ? TaskItem(
                      itemTitle: 'Attached Files',
                      itemWidget: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 10,
                          maxHeight: 250,
                          minWidth: double.infinity,
                        ),
                        child: taskFileReceiver.length !=0 ? SingleChildScrollView(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: taskFileReceiver.length,
                            itemBuilder: (context, index){
                              return TextButton(
                                child: Text(taskFileReceiver[index].fileName),
                                onPressed: (){
                                  downloadTaskFile(taskFileReceiver[index].fileName, taskFilePath);
                                },
                              );
                            },
                          ),
                        ) : Text('No Files Attached'),
                      ),
                    ) : Container(),
                    taskFilePath != null ? Divider() : Container(),
                    TaskItem(
                      itemTitle: 'Assign Member',
                      itemWidget: Row(
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
                                  ).then((value) {
                                    getTaskData();
                                  });
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
                    ),
                  ],
                ),
                TaskFormCard(
                  cardTitle: 'Extras',
                  cardItemList: [
                    TaskItem(
                      itemTitle: 'Start Date',
                      itemWidget: TextButton(
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
                      ),
                    ),
                    Divider(),
                    TaskItem(
                      itemTitle: 'Due Date',
                      itemWidget: TextButton(
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
                    ),
                  ],
                ),
                TaskFormButton(
                  buttonText: taskStatus==1 ? 'Mark task as complete' : 'Re-activate task',
                  buttonColor: Colors.black45,
                  buttonFunction: allowUserEdit == true ? () {
                    LoadingScreen.showLoadingScreen(context, editTaskScaffoldKey);

                    changeTaskStatus(context, taskID, taskStatus).then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
                  } : null,
                ),
                TaskFormButton(
                  buttonText: 'Delete',
                  buttonColor: Colors.red,
                  buttonFunction: allowUserEdit == true ? () {
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
                TaskFormButton(
                  buttonText: 'Save',
                  buttonColor: Colors.amber,
                  buttonFunction: allowUserEdit==true ? () {
                    if(taskNameController.text.isNotEmpty && taskDescController.text.isNotEmpty && taskStatusMsgController.text.isNotEmpty){
                      LoadingScreen.showLoadingScreen(context, editTaskScaffoldKey);

                      String startDate = taskStartDate.toString();
                      String dueDate = taskDueDate.toString();
                      int taskColor = colorList.indexOf(selectedColor);
                      int taskPriority = priorityList.indexOf(selectedPriority);

                      updateTask(context, taskID, taskNameController.text, taskDescController.text, taskStatusMsgController.text, taskColor, taskPriority, startDate, dueDate, attachedFilePaths).then((value) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      });
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name, description & status cannot be empty')));
                    }
                  } : null,
                ),
              ],
            ),
          ),
        ),
    );
  }
}

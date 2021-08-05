import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/model/Task.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';

class taskDetail extends StatefulWidget {

  final int taskID;

  const taskDetail({Key key, this.taskID}) : super(key: key);

  @override
  _taskDetailState createState() => _taskDetailState(taskID);
}

class _taskDetailState extends State<taskDetail> {

  final int taskID;

  _taskDetailState(this.taskID);

  GlobalKey<ScaffoldState> editTaskScaffoldKey = GlobalKey();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescController = TextEditingController();
  TextEditingController taskStatusController = TextEditingController();

  DateTime taskStartDate, taskDueDate;
  bool isStartDueDateEnabled = false;
  bool allowUserEdit = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaskByID(taskID).then((value) {
      taskNameController.text = value.taskName;
      taskDescController.text = value.taskDesc;
      taskStatusController.text = value.taskStatus;

      if(value.taskStartDate != "null" || value.taskDueDate != "null"){

        setState(() {
          taskStartDate = convertStringToDateTime(value.taskStartDate);
          taskDueDate = convertStringToDateTime(value.taskDueDate);
          isStartDueDateEnabled = true;
        });
      }

      checkToAllowEdit(value);
    });
  }

  void checkToAllowEdit(Task task) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int userID = sharedPreferences.getInt("UserID");
    List<String> collabUserID = task.taskCollabUserID.split(',');
    List<String> assignedUserID = task.taskAssignedMemberID.split(',');

    bool taskCreator = false;
    bool taskCollabUser = false;
    bool taskAssignedUser = false;

    // check if the task creator is the current user
    if(userID.toString() == task.taskUserCreateID){
     taskCreator = true;
    }
    // check if current user is the collab user
    for(int i=0; i < collabUserID.length; i++){
      if(collabUserID[i] == userID.toString()){
        taskCollabUser = true;
      }
    }
    // check if current user is being assigned to this task
    for(int j=0; j < assignedUserID.length; j++){
      if(assignedUserID[j] == userID.toString()){
        taskCollabUser = true;
      }
    }

    // determine if user can edit or not
    if(taskCreator || taskCollabUser || taskAssignedUser){
      setState(() {
        allowUserEdit = true;
      });
    }else{
      setState(() {
        allowUserEdit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('Edit Task'),
        ),
        body: CardSettings(
          children: [
            CardSettingsSection(
              header: CardSettingsHeader(
                label: 'Task basic info',
                color: Colors.amber,
              ),
              children: [
                CardSettingsText(
                  label: 'Task Name',
                  enabled: allowUserEdit,
                  controller: taskNameController,
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                ),
                CardSettingsText(
                  label: 'Task Description',
                  enabled: allowUserEdit,
                  controller: taskDescController,
                  numberOfLines: 5,
                ),
                CardSettingsText(
                  label: 'Task Status',
                  enabled: allowUserEdit,
                  controller: taskStatusController,
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                )
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: 'Extras',
                color: Colors.amber,
              ),
              children: [
                CardSettingsSwitch(
                  label: 'Enable start/due date section',
                  initialValue: isStartDueDateEnabled,
                  fieldPadding: EdgeInsets.fromLTRB(10, 10, 10 , 5),
                  onChanged: (bool){
                    setState(() {
                      isStartDueDateEnabled = bool;
                    });
                  },
                ),
                CardSettingsDateTimePicker(
                  enabled: isStartDueDateEnabled,
                  initialValue: taskStartDate,
                  label: 'Start Date \n' + taskStartDate.toString(),
                  onChanged: (dateTime){
                    setState(() {
                      taskStartDate = dateTime;
                    });
                  },
                ),
                CardSettingsDateTimePicker(
                  enabled: isStartDueDateEnabled,
                  initialValue: taskDueDate,
                  label: 'Due Date \n' + taskDueDate.toString(),
                  onChanged: (dateTime){
                    setState(() {
                      taskDueDate = dateTime;
                    });
                  },
                )
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: 'Action',
                color: Colors.amber,
              ),
              children: [
                CardSettingsButton(
                    label: 'Save',
                    onPressed: (){
                      if(taskNameController.text != null || taskDescController.text != null || taskStatusController.text != null){
                        LoadingScreen.showLoadingScreen(context, editTaskScaffoldKey);

                        String startDate = taskStartDate.toString();
                        String dueDate = taskDueDate.toString();

                        updateTask(context, taskID, taskNameController.text, taskDescController.text, taskStatusController.text, startDate, dueDate).then((value) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        });
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name, description & status cannot be empty')));
                      }
                    }
                )
              ],
            )
          ],
        )
    );
  }
}

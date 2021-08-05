import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';

class createTask extends StatefulWidget {

  final int taskListID;

  const createTask({Key key, this.taskListID}) : super(key: key);

  @override
  _createTaskState createState() => _createTaskState(taskListID);
}

class _createTaskState extends State<createTask> {

  final int taskListID;

  _createTaskState(this.taskListID);

  GlobalKey<ScaffoldState> createTaskScaffoldKey = GlobalKey();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescController = TextEditingController();
  TextEditingController taskStatusController = TextEditingController();

  DateTime taskStartDate, taskDueDate;
  bool isStartDueDateEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('New Task'),
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
                controller: taskNameController,
                contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              ),
              CardSettingsText(
                label: 'Task Description',
                controller: taskDescController,
                numberOfLines: 5,
              ),
              CardSettingsText(
                label: 'Task Status',
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
                fieldPadding: EdgeInsets.fromLTRB(10, 10, 10 , 5),
                onChanged: (bool){
                  setState(() {
                    isStartDueDateEnabled = bool;
                  });
                },
              ),
              CardSettingsDateTimePicker(
                enabled: isStartDueDateEnabled,
                label: 'Start Date',
                onChanged: (dateTime){
                  setState(() {
                    taskStartDate = dateTime;
                  });
                },
              ),
              CardSettingsDateTimePicker(
                enabled: isStartDueDateEnabled,
                label: 'Due Date',
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
                  if(taskNameController.text == null || taskDescController.text == null || taskStatusController.text == null){
                    LoadingScreen.showLoadingScreen(context, createTaskScaffoldKey);
                    createNewTask(context, taskListID, taskNameController.text, taskDescController.text, taskStatusController.text, taskStartDate, taskDueDate).then((value) {
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
import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';

class createTask extends StatefulWidget {

  final int taskListID;
  final int teamID;

  const createTask({Key key, this.taskListID, this.teamID}) : super(key: key);

  @override
  _createTaskState createState() => _createTaskState(taskListID, teamID);
}

class _createTaskState extends State<createTask> {

  final int taskListID;
  final int teamID;

  _createTaskState(this.taskListID, this.teamID);

  GlobalKey<ScaffoldState> createTaskScaffoldKey = GlobalKey();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescController = TextEditingController();
  TextEditingController taskStatusController = TextEditingController();

  DateTime taskStartDate, taskDueDate;

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
        middle: Text('New Task'),
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
                              controller: taskStatusController,
                              maxLines: 1,
                              minLines: 1,
                              decoration: textFieldInputDecoration,
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
                                onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (_){
                                        return Dialog(
                                          child: SfDateRangePicker(
                                            enablePastDates: false,
                                            showActionButtons: true,
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
                                },
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
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (_){
                                      return Dialog(
                                        child: SfDateRangePicker(
                                          showActionButtons: true,
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
                              },
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
                    onPressed: () {
                      if(taskNameController.text.isNotEmpty && taskDescController.text.isNotEmpty && taskStatusController.text.isNotEmpty){
                        LoadingScreen.showLoadingScreen(context, createTaskScaffoldKey);
                        String startDate = taskStartDate.toString();
                        String dueDate = taskDueDate.toString();

                        createNewTask(context, taskListID, teamID, taskNameController.text, taskDescController.text, taskStatusController.text, startDate, dueDate).then((value) {
                          Navigator.of(context).pop();
                          taskNameController.clear();
                          taskDescController.clear();
                          taskStatusController.clear();
                        });
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name, description & status cannot be empty')));
                      }
                    },
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

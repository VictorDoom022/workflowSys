import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/view/misc/TaskForm.dart';
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
  List<String> colorList = ['Default', 'Blue', 'Red', 'Yellow', 'Green', 'Grey', 'Black'];
  List<String> priorityList = ['Very Low', 'Low', 'Medium (Default)', 'High', 'Very High'];
  String selectedColor = 'Default';
  String selectedPriority = 'Medium (Default)';

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
              TaskFormCard(
                cardTitle: 'Task basic info',
                cardItemList: [
                  TaskItem(
                    itemTitle: 'Task Name',
                    itemWidget: TextField(
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
                      controller: taskDescController,
                      maxLines: 10,
                      decoration: textFieldInputDecoration,
                    ),
                  ),
                  Divider(),
                  TaskItem(
                    itemTitle: 'Task Status',
                    itemWidget: TextField(
                      controller: taskStatusController,
                      maxLines: 1,
                      minLines: 1,
                      decoration: textFieldInputDecoration,
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
                    ),
                  ),
                  Divider(),
                  TaskItem(
                    itemTitle: 'Due Date',
                    itemWidget: TextButton(
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
              TaskFormButton(
                buttonText: 'Save',
                buttonColor: Colors.amber,
                buttonFunction: () {
                  if(taskNameController.text.isNotEmpty && taskDescController.text.isNotEmpty && taskStatusController.text.isNotEmpty){
                    LoadingScreen.showLoadingScreen(context, createTaskScaffoldKey);
                    String startDate = taskStartDate.toString();
                    String dueDate = taskDueDate.toString();
                    int taskColor = colorList.indexOf(selectedColor);
                    int taskPriority = priorityList.indexOf(selectedPriority);

                    createNewTask(context, taskListID, teamID, taskNameController.text, taskDescController.text, taskStatusController.text, taskColor, taskPriority ,startDate, dueDate).then((value) {
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
            ],
          ),
        ),
      ),
    );
  }
}

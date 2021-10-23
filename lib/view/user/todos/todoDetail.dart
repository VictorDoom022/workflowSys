import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/todoController.dart';
import 'package:workflow_sys/view/misc/TaskForm.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';

class todoDetail extends StatefulWidget {

  final int todoID;

  const todoDetail({Key? key, required this.todoID}) : super(key: key);

  @override
  _todoDetailState createState() => _todoDetailState(todoID);
}

class _todoDetailState extends State<todoDetail> {

  final int todoID;

  _todoDetailState(this.todoID);

  GlobalKey<ScaffoldState> toDoDetailScaffoldKey = GlobalKey();

  TextEditingController todoNameController = TextEditingController();
  TextEditingController todoDescController = TextEditingController();
  TextEditingController todoStatusMsgController = TextEditingController();

  DateTime? todoStartDate, todoDueDate;
  int? todoStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodoByID(context, todoID).then((value) {
      todoNameController.text = value.todoName!;
      todoDescController.text = value.todoDesc!;
      todoStatusMsgController.text = value.todoStatusMsg!;

      setState(() {
        todoStatus = value.todoStatus;
      });

      if(value.todoStartDate != "null"){
        setState(() {
          todoStartDate = convertStringToDateTime(value.todoStartDate!);
        });
      }

      if(value.todoDueDate != "null"){
        setState(() {
          todoDueDate = convertStringToDateTime(value.todoDueDate!);
        });
      }
    });
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
        middle: Text('Edit Todo'),
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
                    itemTitle: 'Name',
                    itemWidget: TextField(
                      controller: todoNameController,
                      decoration: textFieldInputDecoration,
                    ),
                  ),
                  Divider(),
                  TaskItem(
                    itemTitle: 'Description',
                    itemWidget: TextField(
                      controller: todoDescController,
                      maxLines: 10,
                      decoration: textFieldInputDecoration,
                    ),
                  ),
                  Divider(),
                  TaskItem(
                    itemTitle: 'Status',
                    itemWidget: TextField(
                      controller: todoStatusMsgController,
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
                      child: Text(todoStartDate==null ? 'Select date' : todoStartDate.toString()),
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (_){
                              return Dialog(
                                child: SfDateRangePicker(
                                  showActionButtons: true,
                                  initialDisplayDate: todoStartDate,
                                  initialSelectedDate: todoStartDate,
                                  onSubmit: (date){
                                    Navigator.of(context).pop();
                                    setState(() {
                                      todoStartDate = date as DateTime?;
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
                      child: Text(todoDueDate==null ? 'Select date' : todoDueDate.toString()),
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (_){
                              return Dialog(
                                child: SfDateRangePicker(
                                  showActionButtons: true,
                                  initialDisplayDate: todoDueDate,
                                  initialSelectedDate: todoDueDate,
                                  onSubmit: (date){
                                    Navigator.of(context).pop();
                                    setState(() {
                                      todoDueDate = date as DateTime?;
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
                buttonText: todoStatus==1 ? 'Archive' : 'Unarchive',
                buttonColor: Colors.black45,
                buttonFunction: () {
                  LoadingScreen.showLoadingScreen(context, toDoDetailScaffoldKey);

                  changeTodoStatus(context, todoID, todoStatus!).then((value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                },
              ),
              TaskFormButton(
                buttonText: 'Delete',
                buttonColor: Colors.red,
                buttonFunction: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (_){
                        return CupertinoAlertDialog(
                          content: Text(
                            'Are you sure you want to delete this todo?',
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
                                LoadingScreen.showLoadingScreen(context, toDoDetailScaffoldKey);
                                deleteTodo(context, todoID).then((value) {
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
                },
              ),
              TaskFormButton(
                buttonText: 'Save',
                buttonColor: Colors.amber,
                buttonFunction: () {
                  if(todoNameController.text.isNotEmpty && todoDescController.text.isNotEmpty && todoStatusMsgController.text.isNotEmpty){
                    LoadingScreen.showLoadingScreen(context, toDoDetailScaffoldKey);

                    String startDate = todoStartDate.toString();
                    String dueDate = todoDueDate.toString();

                    updateTodo(context, todoID, todoNameController.text, todoDescController.text, todoStatusMsgController.text, startDate, dueDate).then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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

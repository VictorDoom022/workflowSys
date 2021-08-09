import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/todoController.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';

class todoDetail extends StatefulWidget {

  final int todoID;

  const todoDetail({Key key, this.todoID}) : super(key: key);

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

  DateTime todoStartDate, todoDueDate;
  int todoStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodoByID(todoID).then((value) {
      todoNameController.text = value.todoName;
      todoDescController.text = value.todoDesc;
      todoStatusMsgController.text = value.todoStatusMsg;

      setState(() {
        todoStatus = value.todoStatus;
      });

      if(value.todoStartDate != "null" || value.todoDueDate != "null"){
        setState(() {
          todoStartDate = convertStringToDateTime(value.todoStartDate);
          todoDueDate = convertStringToDateTime(value.todoDueDate);
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
                            child: Text('Name'),
                          ),
                          Expanded(
                            flex: 9,
                            child: TextField(
                              controller: todoNameController,
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
                            child: Text('Description'),
                          ),
                          Expanded(
                            flex: 9,
                            child: TextField(
                              controller: todoDescController,
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
                            child: Text('Status'),
                          ),
                          Expanded(
                            flex: 9,
                            child: TextField(
                              controller: todoStatusMsgController,
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
                                                todoStartDate = date;
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
                                              todoDueDate = date;
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
                      todoStatus==1 ? 'Mark task as complete' : 'Re-activate task',
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
                      // LoadingScreen.showLoadingScreen(context, editTaskScaffoldKey);
                      //
                      // changeTaskStatus(context, taskID, taskStatus).then((value) {
                      //   Navigator.of(context).pop();
                      //   Navigator.of(context).pop();
                      // });
                    },
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
                    onPressed: () {
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
                                    // LoadingScreen.showLoadingScreen(context, editTaskScaffoldKey);
                                    // deleteTask(context, taskID).then((value) {
                                    //   Navigator.of(context).pop();
                                    //   Navigator.of(context).pop();
                                    //   Navigator.of(context).pop();
                                    // });
                                  },
                                )
                              ],
                            );
                          }
                      );
                    },
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

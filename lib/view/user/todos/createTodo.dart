import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:workflow_sys/controller/todoController.dart';
import 'package:workflow_sys/view/misc/TaskForm.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/userNavDrawer.dart';

class createTodo extends StatefulWidget {
  const createTodo({Key key}) : super(key: key);

  @override
  _createTodoState createState() => _createTodoState();
}

class _createTodoState extends State<createTodo> {

  GlobalKey<ScaffoldState> userCreateTodoScaffoldKey = GlobalKey();
  GlobalKey<ScaffoldState> userCreateTodoSecondScaffoldKey = GlobalKey();

  TextEditingController todoNameController = TextEditingController();
  TextEditingController todoDescController = TextEditingController();
  TextEditingController todoStatusMsgController = TextEditingController();

  DateTime todoStartDate, todoDueDate;

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
      key: userCreateTodoScaffoldKey,
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.list),
          onPressed: (){
            userCreateTodoScaffoldKey.currentState.openDrawer();
          },
        ),
        middle: Text('New Todo'),
      ),
      drawer: userNavDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TaskFormCard(
                cardTitle: 'Todo basic info',
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
                                  enablePastDates: false,
                                  showActionButtons: true,
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
                  ),
                ],
              ),
              Divider(),
              TaskFormButton(
                buttonText: 'Save',
                buttonColor: Colors.amber,
                buttonFunction: () {
                  if(todoNameController.text.isNotEmpty && todoDescController.text.isNotEmpty && todoStatusMsgController.text.isNotEmpty){
                    LoadingScreen.showLoadingScreen(context, userCreateTodoSecondScaffoldKey);
                    String startDate = todoStartDate.toString();
                    String dueDate = todoDueDate.toString();

                    createNewTodo(context, todoNameController.text, todoDescController.text, todoStatusMsgController.text, startDate, dueDate).then((value) {
                      Navigator.of(context).pop();
                      todoNameController.clear();
                      todoDescController.clear();
                      todoStatusMsgController.clear();
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

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/todoController.dart';
import 'package:workflow_sys/model/ToDo.dart';
import 'package:workflow_sys/view/misc/TodoCard.dart';
import 'package:workflow_sys/view/user/todos/todoDetail.dart';
import 'package:workflow_sys/view/user/todos/todoList.dart';

import '../userNavDrawer.dart';

class todoArchived extends StatefulWidget {
  const todoArchived({Key? key}) : super(key: key);

  @override
  _todoArchivedState createState() => _todoArchivedState();
}

class _todoArchivedState extends State<todoArchived> {

  GlobalKey<ScaffoldState> userTodoArchiveListScaffoldKey = GlobalKey();

  RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<List<ToDo>>? futureTodoArchiveList;
  String searchKeyWord="";
  String dropDownSortValue = "Default";
  List<String> dropDownListSelections = ['Default', 'Name Desc', 'Updated Asc', 'Updated Desc', 'Create At Asc', 'Create At Desc'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodoArchiveListData();
  }

  Future<void> getTodoArchiveListData() async {
    List<ToDo> todoList = await getToDoArchivedList();
    todoList.sort((a,b) => a.todoName!.compareTo(b.todoName!));

    setState(() {
      futureTodoArchiveList = Future.value(todoList);
    });
    refreshController.refreshCompleted();
  }

  void sortList(String sortType) async {
    List<ToDo>? todoList = await futureTodoArchiveList;

    if(sortType == dropDownListSelections[0]){
      todoList!.sort((a,b) => a.todoName!.compareTo(b.todoName!));
    }else if(sortType == dropDownListSelections[1]){
      todoList!.sort((a,b) => b.todoName!.compareTo(a.todoName!));
    }else if(sortType == dropDownListSelections[2]){
      todoList!.sort((a,b) => a.updatedAt!.compareTo(b.updatedAt!));
    }else if(sortType == dropDownListSelections[3]){
      todoList!.sort((a,b) => b.updatedAt!.compareTo(a.updatedAt!));
    }else if(sortType == dropDownListSelections[4]){
      todoList!.sort((a,b) => a.createdAt!.compareTo(b.createdAt!));
    }else if(sortType == dropDownListSelections[5]){
      todoList!.sort((a,b) => b.createdAt!.compareTo(a.createdAt!));
    }

    setState(() {
      futureTodoArchiveList = Future.value(todoList);
    });
  }

  Future<List<ToDo>> searchList() async {
    List<ToDo>? listTodo = await futureTodoArchiveList;
    List<ToDo> searchList = [];

    if(searchKeyWord == ""){
      searchList = listTodo!;
    }else {
      for(int i=0; i < listTodo!.length; i++){
        if(listTodo[i].todoName!.toLowerCase().contains(searchKeyWord.toLowerCase()) == true){
          searchList.add(listTodo[i]);
        }
      }
    }

    return searchList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: userTodoArchiveListScaffoldKey,
      appBar: Platform.isAndroid || Platform.isIOS ? CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.list),
          onPressed: (){
            userTodoArchiveListScaffoldKey.currentState!.openDrawer();
          },
        ),
        middle: Text('Todo List'),
      ) : null,
      drawer: Platform.isAndroid || Platform.isIOS ? userNavDrawer() : null,
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
              onRefresh: getTodoArchiveListData,
              child: FutureBuilder<List<ToDo>>(
                future: searchKeyWord=="" ? futureTodoArchiveList : searchList(),
                builder: (context, snapshot){
                  if(snapshot.hasError) print(snapshot.error);

                  if(snapshot.hasData){
                    if(snapshot.data.toString() != "[]"){
                      List<ToDo> todoList = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: todoList.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: GestureDetector(
                              child: TodoCard(
                                todoDate: convertBackendDateTimeToDate(todoList[index].createdAt!),
                                todoMonth: convertBackendDateTimeToMonth(todoList[index].createdAt!),
                                name: todoList[index].todoName!,
                                lastUpdatedTime: convertBackendDateTime(todoList[index].updatedAt),
                                statusMsg: todoList[index].todoStatusMsg!,
                                desc: todoList[index].todoDesc!,
                              ),
                              onTap: (){
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (_){
                                          return todoDetail(todoID: todoList[index].id!);
                                        }
                                    )
                                ).then((value) {
                                  getTodoArchiveListData();
                                });
                              },
                            ),
                          );
                        },
                      );
                    }else{
                      return Center(child: Text('No archived item'));
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
}

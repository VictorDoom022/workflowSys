import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/todoController.dart';
import 'package:workflow_sys/model/ToDo.dart';
import 'package:workflow_sys/view/misc/TodoCard.dart';
import 'package:workflow_sys/view/user/todos/todoDetail.dart';

import '../userNavDrawer.dart';

class todoList extends StatefulWidget {
  const todoList({Key key}) : super(key: key);

  @override
  _todoListState createState() => _todoListState();
}

class _todoListState extends State<todoList> {

  GlobalKey<ScaffoldState> userTodoListScaffoldKey = GlobalKey();

  RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<List<ToDo>> futureTodoList;
  String searchKeyWord="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodoListData();
  }

  Future<void> getTodoListData() async {
    List<ToDo> todoList = await getTodoList();
    setState(() {
      futureTodoList = Future.value(todoList);
    });
    refreshController.refreshCompleted();
  }

  Future<List<ToDo>> searchList() async {
    List<ToDo> listTodo = await futureTodoList;
    List<ToDo> searchList = [];

    if(searchKeyWord == ""){
      searchList = listTodo;
    }else {
      for(int i=0; i < listTodo.length; i++){
        if(listTodo[i].todoName.toLowerCase().contains(searchKeyWord.toLowerCase()) == true){
          searchList.add(listTodo[i]);
        }
      }
    }

    return searchList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: userTodoListScaffoldKey,
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.list),
          onPressed: (){
            userTodoListScaffoldKey.currentState.openDrawer();
          },
        ),
        middle: Text('Todo List'),
      ),
      drawer: userNavDrawer(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
            child: SmartRefresher(
              controller: refreshController,
              enablePullDown: true,
              header: BezierCircleHeader(),
              onRefresh: getTodoListData,
              child: FutureBuilder<List<ToDo>>(
                future: searchKeyWord=="" ? futureTodoList : searchList(),
                builder: (context, snapshot){
                  if(snapshot.hasError) print(snapshot.error);

                  if(snapshot.hasData){
                    if(snapshot.data.toString() != "[]"){
                      List<ToDo> todoList = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: todoList.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: GestureDetector(
                              child: TodoCard(
                                todoDate: convertBackendDateTimeToDate(todoList[index].createdAt),
                                todoMonth: convertBackendDateTimeToMonth(todoList[index].createdAt),
                                name: todoList[index].todoName,
                                lastUpdatedTime: convertBackendDateTime(todoList[index].updatedAt),
                                statusMsg: todoList[index].todoStatusMsg,
                                desc: todoList[index].todoDesc,
                              ),
                              onTap: (){
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (_){
                                          return todoDetail(todoID: todoList[index].id);
                                        }
                                    )
                                ).then((value) {
                                  getTodoListData();
                                });
                              },
                            ),
                          );
                        },
                      );
                    }else{
                      return Center(child: Text('No todo created'));
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

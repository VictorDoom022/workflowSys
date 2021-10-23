import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:workflow_sys/view/user/todos/createTodo.dart';
import 'package:workflow_sys/view/user/todos/todoArchived.dart';
import 'package:workflow_sys/view/user/todos/todoList.dart';

class todoHome extends StatefulWidget {
  const todoHome({Key? key}) : super(key: key);

  @override
  _todoHomeState createState() => _todoHomeState();
}

class _todoHomeState extends State<todoHome> {

  Widget? currentWidget;
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      currentWidget = screenList()[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TitledBottomNavigationBar(
        items: itemList,
        currentIndex: _currentIndex,
        onTap: (selected){
          setState(() {
            _currentIndex = selected;
          });
        },
      ),
      body: screenList()[_currentIndex],
    );
  }

  List<TitledNavigationBarItem> itemList = [
    TitledNavigationBarItem(
        icon: Icon(Icons.list_alt),
        title: Text('Todo List')
    ),
    TitledNavigationBarItem(
        icon: Icon(Icons.playlist_add),
        title: Text('Create Todo')
    ),
    TitledNavigationBarItem(
        icon: Icon(Icons.archive_outlined),
        title: Text('Archived')
    ),
  ];

  List<Widget> screenList() {
    return [
      todoList(),
      createTodo(),
      todoArchived(),
    ];
  }
}

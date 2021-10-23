import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/model/User.dart';

class taskAssignedHistory extends StatefulWidget {

  final List<User> userList;
  final List<String> assignedUserList;
  final List<String> assignedDateList;

  const taskAssignedHistory({Key? key, required this.userList, required this.assignedUserList, required this.assignedDateList}) : super(key: key);

  @override
  _taskAssignedHistoryState createState() => _taskAssignedHistoryState(userList, assignedUserList, assignedDateList);
}

class _taskAssignedHistoryState extends State<taskAssignedHistory> {

  final List<User> userList;
  final List<String> assignedUserList;
  final List<String> assignedDateList;

  _taskAssignedHistoryState(this.userList, this.assignedUserList, this.assignedDateList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Assigned History'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: assignedDateList.length,
        itemBuilder: (context, index){
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      dateFromEpoch(int.parse(assignedDateList[index])),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      convertUserIDtoName(assignedUserList[index])!,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String? convertUserIDtoName(String userID){
    for(int i=0; i < userList.length; i++){
      if(userID == userList[i].id.toString()){
        return userList[i].name;
      }
    }
  }
}

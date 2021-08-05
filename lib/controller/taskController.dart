import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';

import 'miscController.dart';

Future<void> createNewTask(BuildContext context, int taskListID, String taskName, String taskDesc, String taskStatus, DateTime taskStartDate, DateTime taskDueDate) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");
  int userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/task/createTask';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'userID' : userID.toString(),
        'taskListID' : taskListID.toString(),
        'taskName' : taskName,
        'taskDesc' : taskDesc,
        'taskStartDate': taskStartDate.toString(),
        'taskDueDate' : taskDueDate.toString(),
        'taskStatus' : taskStatus
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convertResponseMessage(response.body))));
  }
}
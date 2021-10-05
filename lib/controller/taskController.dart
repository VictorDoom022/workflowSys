import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/model/FileReceiver.dart';
import 'package:workflow_sys/model/Task.dart';

import 'miscController.dart';

Future<void> createNewTask(BuildContext context, int taskListID, int taskTeamID ,String taskName, String taskDesc, String taskStatusMsg, int taskColor, int taskPriority,String taskStartDate, String taskDueDate, List<String> attachedFilePaths) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");
  int userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/task/createTask';
  Uri url = Uri.parse(stringUrl);
  Map<String, String> headers = {
    "Accept": "application/json",
    "Authorization": "Bearer " + token
  };

  var request = http.MultipartRequest('Post', url);
  request.headers.addAll(headers);
  request.fields['userID'] = userID.toString();
  request.fields['taskListID'] = taskListID.toString();
  request.fields['taskTeamID'] = taskTeamID.toString();
  request.fields['taskName'] = taskName;
  request.fields['taskDesc'] = taskDesc;
  request.fields['taskDetailedDesc'] = ''; // flutter does not support rich text editor
  request.fields['taskStartDate'] = taskStartDate;
  request.fields['taskDueDate'] = taskDueDate;
  request.fields['taskStatusMsg'] = taskStatusMsg;
  request.fields['taskColor'] = taskColor.toString();
  request.fields['taskPriority'] = taskPriority.toString();
  for(int i=0; i < attachedFilePaths.length; i++){
    request.files.add(
      await http.MultipartFile.fromPath(
        'taskFiles[]',
          attachedFilePaths[i]
      )
    );
  }

  var response = await request.send();

  if(response.statusCode == 200){
    response.stream.transform(utf8.decoder).listen((value) {
      String messageText = convertResponseMessage(value);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messageText)));
    });
  }
}

Future<List<Task>> getTaskByTaskListID(int taskListID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/task/getTaskByTaskListID';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'taskListID' : taskListID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  List<Task> listTask = [];
  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    listTask = (jsonRes as List).map((e) => Task.fromJson(e)).toList();

    return listTask;
  }else{
    return listTask;
  }
}

Future<Task> getTaskByID(BuildContext context, int taskID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/task/getTaskByID';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'taskID' : taskID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );


  if(response.statusCode == 200){
    if(response.body != ""){
      return Task.fromJson(jsonDecode(response.body));
    }else{
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please pull to refresh and try again')));
    }
  }
}

Future<void> updateTask(BuildContext context, int taskID, String taskName, String taskDesc, String taskStatusMsg, int taskColor, int taskPriority, String taskStartDate, String taskDueDate, List<String> attachedFilePaths) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/task/updateTask';
  Uri url = Uri.parse(stringUrl);
  Map<String, String> headers = {
    "Accept": "application/json",
    "Authorization": "Bearer " + token
  };

  var request = http.MultipartRequest('Post', url);
  request.headers.addAll(headers);
  request.fields['taskID'] = taskID.toString();
  request.fields['taskName'] = taskName;
  request.fields['taskDesc'] = taskDesc;
  request.fields['taskStartDate'] = taskStartDate;
  request.fields['taskDueDate'] = taskDueDate;
  request.fields['taskStatusMsg'] = taskStatusMsg;
  request.fields['taskColor'] = taskColor.toString();
  request.fields['taskPriority'] = taskPriority.toString();
  for(int i=0; i < attachedFilePaths.length; i++){
    request.files.add(
        await http.MultipartFile.fromPath(
            'taskFiles[]',
            attachedFilePaths[i]
        )
    );
  }

  var response = await request.send();

  if(response.statusCode == 200){
    response.stream.transform(utf8.decoder).listen((value) {
      String messageText = convertResponseMessage(value);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messageText)));
    });
  }
}

Future<void> assignTask(BuildContext context, int taskID, int assignedUserID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/task/assignTask';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'taskID' : taskID.toString(),
        'assignedUserID' : assignedUserID.toString(),
        'taskAssignedDate' : epochFromDate(DateTime.now()).toString(),
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

Future<List<Task>> getTaskAssignedToUser(int taskListID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");
  int userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/task/taskAssignedToUser';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'taskListID' : taskListID.toString(),
        'userID' : userID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  List<Task> listTask = [];
  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    listTask = (jsonRes as List).map((e) => Task.fromJson(e)).toList();

    return listTask;
  }else{
    return listTask;
  }
}

Future<void> changeTaskStatus(BuildContext context, int taskID, int taskStatus) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/task/changeTaskStatus';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'taskID' : taskID.toString(),
        'taskStatus' : taskStatus.toString(),
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

Future<List<Task>> getCompletedTaskByTaskListID(int taskListID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/task/getCompletedTaskByTaskListID';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'taskListID' : taskListID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  List<Task> listTask = [];
  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    listTask = (jsonRes as List).map((e) => Task.fromJson(e)).toList();

    return listTask;
  }else{
    return listTask;
  }
}

Future<void> deleteTask(BuildContext context, int taskID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/task/deleteTaskByTaskID/' + taskID.toString();
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convertResponseMessage(response.body))));
  }
}

Future<List<FileReceiver>> fetchTaskFiles(String filePath) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/task/getTaskFilesByPath';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'filePath' : filePath,
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  List<FileReceiver> listFileReceiver = [];
  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    listFileReceiver = (jsonRes as List).map((e) => FileReceiver.fromJson(e)).toList();

    return listFileReceiver;
  }else{
    return listFileReceiver;
  }
}

Future<void> downloadTaskFile(String fileName, String filePath) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String encodeFileName = Uri.encodeComponent(fileName);
  String encodeFilePath = Uri.encodeComponent(filePath);
  String fullLink = '"$encodeFileName"/"$encodeFilePath"/"$token"';
  String newUrl = webServerURL + '/downloadTaskFile/$fullLink';

  /*
    since windows & macOS does not support flutter_downloader plugin
    use web version to download file instead
  */
  await launch(newUrl);
}

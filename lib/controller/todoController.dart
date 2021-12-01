import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/model/ToDo.dart';
import 'package:http/http.dart' as http;

import 'miscController.dart';

Future<List<ToDo>> getTodoList(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");
  int? userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/todo/getToDoByUserID';
  Uri url = Uri.parse(stringUrl);
  try{
    var response = await http.post(
        url,
        body: {
          'userID': userID.toString(),
        },
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer ' + token!
        }
    );

    if(response.statusCode == 200){
      var jsonRes = jsonDecode(response.body);
      List<ToDo> listToDo = (jsonRes as List).map((e) => ToDo.fromJson(e)).toList();

      return listToDo;
    }else{
      throw 'Error';
    }
  }on SocketException catch (_){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            dismissDirection: DismissDirection.none,
            content: Text('Could not connect to server')
        )
    );
    throw 'Null';
  }
}

Future<void> createNewTodo(BuildContext context, String todoName, String todoDesc, String todoStatusMsg, String todoStartDate, String todoDueDate) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");
  int? userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/todo/createTodo';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'userID' : userID.toString(),
        'todoName' : todoName,
        'todoDesc' : todoDesc,
        'todoStartDate' : todoStartDate.toString(),
        'todoDueDate' : todoDueDate.toString(),
        'todoStatusMsg': todoStatusMsg,
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token!
      }
  );

  if(response.statusCode == 200){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convertResponseMessage(response.body))));
  }
}

Future<ToDo> getTodoByID(BuildContext context, int todoID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/todo/getTodoByID';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'todoID' : todoID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token!
      }
  );


  if(response.statusCode == 200){
    if(response.body != ""){
      return ToDo.fromJson(jsonDecode(response.body));
    }else{
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please pull to refresh and try again')));
      throw 'null';
    }
  }else{
    throw 'Error';
  }
}

Future<void> updateTodo(BuildContext context, int todoID, String todoName, String todoDesc, String todoStatusMsg, String todoStartDate, String todoDueDate) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/todo/updateTodo';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'todoID' : todoID.toString(),
        'todoName' : todoName,
        'todoDesc' : todoDesc,
        'todoStatusMsg' : todoStatusMsg,
        'todoStartDate': todoStartDate,
        'todoDueDate' : todoDueDate,
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token!
      }
  );

  if(response.statusCode == 200){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convertResponseMessage(response.body))));
  }
}

Future<void> deleteTodo(BuildContext context, int todoID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/todo/deleteTodoById/' + todoID.toString();
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token!
      }
  );

  if(response.statusCode == 200){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convertResponseMessage(response.body))));
  }
}

Future<void> changeTodoStatus(BuildContext context, int todoID, int todoStatus) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/todo/changeTodoStatus';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'todoID' : todoID.toString(),
        'todoStatus' : todoStatus.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token!
      }
  );

  if(response.statusCode == 200){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convertResponseMessage(response.body))));
  }
}

Future<List<ToDo>> getToDoArchivedList() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");
  int? userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/todo/getToDoArchivedByUserID';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'userID': userID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token!
      }
  );

  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    List<ToDo> listToDo = (jsonRes as List).map((e) => ToDo.fromJson(e)).toList();

    return listToDo;
  }else{
    throw 'Error';
  }
}

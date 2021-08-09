import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserReceiver.dart';

Future<UserReceiver> getAllUser(BuildContext context) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/users';
  Uri url = Uri.parse(stringUrl);
  var response = await http.get(
      url,
    headers: {
      'Accept': 'application/json',
      'Authorization' : 'Bearer ' + token
    }
  );

  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    //List<User> userList = (jsonRes as List).map((e) => User.fromJson(e)).toList();
    UserReceiver userReceiver = UserReceiver.fromJson(jsonRes);
    return userReceiver;
  }else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ' + response.statusCode.toString())));
    return null;
  }
}

void setUserStatus(BuildContext context, int id, String statusMsg) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/users/setUserStatus';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {'userDetail_id' : id.toString(), 'statusMsg' : statusMsg},
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  String messageText = convertResponseMessage(response.body);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messageText)));
}

void toggleUserBan(BuildContext context, int id) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/users/toggleUserBan/' + id.toString();
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization' : 'Bearer ' + token
    }
  );

  String messageText = convertResponseMessage(response.body);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messageText)));
}
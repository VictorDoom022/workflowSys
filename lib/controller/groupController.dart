import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:http/http.dart' as http;
import 'package:workflow_sys/model/Group.dart';
import 'package:workflow_sys/model/GroupDetailReceiver.dart';

void createGroup(BuildContext context, String groupName) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");
  int userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/createGroup';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {'groupName' : groupName, 'userID' : userID.toString()},
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200){
    Group group = Group.fromJson(jsonDecode(response.body));
    showCupertinoDialog(
        context: context,
        builder: (context){
          return CupertinoAlertDialog(
            title: Text('Join code'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Here's your join code for " + group.groupName),
                Text(
                    group.groupJoinCode,
                    style: TextStyle(
                      fontSize: 17
                    ),
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('Close'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text('Copy'),
                onPressed: (){
                  Clipboard.setData(ClipboardData(text: group.groupJoinCode));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied!')));
                },
              ),
            ],
          );
        }
    );
  }else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred. Code' + response.statusCode.toString())));
  }
}

Future<List<Group>> getUserJoinedGroup(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");
  int userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/group/userID/' + userID.toString();
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  try{
    List<Group> listGroup;
    if(response.body!=""){
      listGroup = (jsonDecode(response.body) as List).map((e) => Group.fromJson(e)).toList();

      return listGroup;
    }else{
      return listGroup;
    }
  }catch(e){
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

Future<GroupDetailReceiver> getGroupDetail(int groupID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/group/getGroupID';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'groupID': groupID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    GroupDetailReceiver groupDetailReceiver = GroupDetailReceiver.fromJson(jsonRes);

    return groupDetailReceiver;
  }
}
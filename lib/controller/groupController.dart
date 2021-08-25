import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:http/http.dart' as http;
import 'package:workflow_sys/model/Group.dart';
import 'package:workflow_sys/model/GroupDetailReceiver.dart';
import 'package:workflow_sys/model/Team.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/view/user/userHome.dart';

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
    List<Group> listGroup = [];
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

Future<GroupDetailReceiver> getGroupDetailByGroupUserID(int groupID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");
  int userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/group/getGroupDetailByGroupUserID';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'groupID': groupID.toString(),
        'userID' : userID.toString(),
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

Future<List<Team>> getGroupTeamByGroupID(int groupID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/group/getGroupTeamByGroupID';
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
    List<Team> teamList = (jsonRes as List).map((e) => Team.fromJson(e)).toList();

    return teamList;
  }
}

Future<void> joinGroup(BuildContext context, String joinCode) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");
  int userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/group/joinGroup';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'userID' : userID.toString(),
        'joinCode': joinCode,
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200 || response.statusCode == 201){
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convertResponseMessage(response.body))));
  }
}

Future<List<User>> getUserNotJoinedTeam(int groupID, int teamID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/team/getTeamUserDiff';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'groupID' : groupID.toString(),
        'teamID' : teamID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    List<User> listUser = (jsonRes as List).map((e) => User.fromJson(e)).toList();

    return listUser;
  }
}

Future<List<User>> getGroupUserByGroupID(int groupID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/group/getGroupUserByGroupID';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'groupID' : groupID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    List<User> listUser = (jsonRes as List).map((e) => User.fromJson(e)).toList();

    return listUser;
  }
}

Future<List<User>> getGroupNonAdminUserList(int groupID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/group/getGroupNonAdminUser';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'groupID' : groupID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    List<User> listUser = (jsonRes as List).map((e) => User.fromJson(e)).toList();

    return listUser;
  }
}

Future<List<User>> getGroupAdminUserList(int groupID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/group/getGroupAdminUser';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'groupID' : groupID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    List<User> listUser = (jsonRes as List).map((e) => User.fromJson(e)).toList();

    return listUser;
  }
}

Future<void> setMemberAsAdmin(BuildContext context, int groupID, List<int> memberList) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/group/setMemberAsAdmin';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'groupID' : groupID.toString(),
        'userList' : memberList.join(','),
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

Future<void> removeMemberFromGroupAdmin(BuildContext context, int groupID, List<int> memberList) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/group/removeMemberFromGroupAdmin';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'groupID' : groupID.toString(),
        'userList' : memberList.join(','),
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

Future<void> deleteGroup(BuildContext context, int groupID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/group/deleteGroup/' + groupID.toString();
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
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (_){
        return userHome();
      })
    );
  }
}

Future<void> renameGroup(BuildContext context, int groupID, String groupName) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/group/renameGroup';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'groupID' : groupID.toString(),
        'groupName' : groupName,
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/model/TeamDetailReceiver.dart';
import 'package:http/http.dart' as http;
import 'package:workflow_sys/model/User.dart';

Future<TeamDetailReceiver> getTeamDetail(int teamID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/team/getTeamID';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'teamID': teamID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token!
      }
  );

  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    TeamDetailReceiver teamDetailReceiver = TeamDetailReceiver.fromJson(jsonRes);

    return teamDetailReceiver;
  }else{
    throw 'Error';
  }
}

void createTeam(BuildContext context, int groupID, String teamName) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");
  int? userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/team/createTeam';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'groupID' : groupID.toString(),
        'userID' : userID.toString(),
        'teamName' : teamName
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token!
      }
  );

  if(response.statusCode == 200){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convertResponseMessage(response.body))));
  }else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.statusCode.toString())));
  }
}

Future<void> addMemberToTeam(BuildContext context, int teamID, List<int> memberIDList) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");

  if(memberIDList.length != 0){
    String stringUrl = apiURL + '/team/addMemberToTeam';
    Uri url = Uri.parse(stringUrl);
    var response = await http.post(
        url,
        body: {
          'userList' : memberIDList.join(','),
          'teamID' : teamID.toString(),
        },
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer ' + token!
        }
    );

    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convertResponseMessage(response.body))));
    }
  }else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No member added')));
  }
}

Future<List<User>> getUserJoinedTeam(int teamID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/team/getTeamUser';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'teamID' : teamID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token!
      }
  );

  List<User> listUser = [];
  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    listUser = (jsonRes as List).map((e) => User.fromJson(e)).toList();

    return listUser;
  }else{
    return listUser;
  }
}

Future<void> removeMemberFromTeam(BuildContext context, int teamID, List<int> memberIDList) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");

  if(memberIDList.length != 0){
    String stringUrl = apiURL + '/team/removeMemberFromTeam';
    Uri url = Uri.parse(stringUrl);
    var response = await http.post(
        url,
        body: {
          'userList' : memberIDList.join(','),
          'teamID' : teamID.toString(),
        },
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer ' + token!
        }
    );

    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convertResponseMessage(response.body))));
    }
  }else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No member removed')));
  }
}

Future<void> deleteTeam(BuildContext context, int teamID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/team/deleteTeam';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'teamID' : teamID.toString(),
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

Future<void> renameTeam(BuildContext context, int teamID, String teamName) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/team/renameTeam';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'teamID' : teamID.toString(),
        'teamName' : teamName,
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

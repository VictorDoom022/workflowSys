import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/model/TeamDetailReceiver.dart';
import 'package:http/http.dart' as http;

Future<TeamDetailReceiver> getTeamDetail(int teamID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/team/getTeamID';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'teamID': teamID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    TeamDetailReceiver teamDetailReceiver = TeamDetailReceiver.fromJson(jsonRes);

    return teamDetailReceiver;
  }
}

void createTeam(BuildContext context, int groupID, String teamName) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");
  int userID = sharedPreferences.getInt("UserID");

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
        'Authorization' : 'Bearer ' + token
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
  String token = sharedPreferences.getString("UserToken");

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
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convertResponseMessage(response.body))));
  }
}
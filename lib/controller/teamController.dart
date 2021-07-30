import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/model/TeamDetailReceiver.dart';
import 'package:http/http.dart' as http;

Future<TeamDetailReceiver> getTeamDetail(int teamID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/group/getGroupID';
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
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:http/http.dart' as http;
import 'package:workflow_sys/model/DashboardData.dart';

Future<DashboardData?> getDashboardData(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");
  int? userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/data/getUserTaskOverview';
  Uri url = Uri.parse(stringUrl);
  try{
    var response = await http.get(
        url.replace(queryParameters: {'userID' : userID.toString()}),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer ' + token!,
        }
    );

    if(response.statusCode == 200){
      var jsonRes = jsonDecode(response.body);
      DashboardData dashboardData = DashboardData.fromJson(jsonRes);

      return dashboardData;
    }
  }on SocketException catch (_){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.none,
        content: Text('Could not connect to server')
      )
    );
    DashboardData dashboardData = DashboardData(totalTask: 0, activeTaskCount: 0, completedTaskCount: 0, highPriorityTaskCount: 0, assignedToUserTaskCount: 0, recentTaskActivityData: [], completedTaskHistoryData: []);

    return dashboardData;
  }
}
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:http/http.dart' as http;
import 'package:workflow_sys/model/DashboardData.dart';

Future<DashboardData?> getDashboardData() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("UserToken");
  int? userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/data/getUserTaskOverview';
  Uri url = Uri.parse(stringUrl);
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
}
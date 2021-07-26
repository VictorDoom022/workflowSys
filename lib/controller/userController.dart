import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserReceiver.dart';

Future<UserReceiver> getAllUser() async{
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

  var jsonRes = jsonDecode(response.body);
  //List<User> userList = (jsonRes as List).map((e) => User.fromJson(e)).toList();
  UserReceiver userReceiver = UserReceiver.fromJson(jsonRes);
  return userReceiver;
}

void setUserStatus(int id, String statusMsg) async {
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

  print(response.body);
}

void toggleUserBan(int id) async {
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

  print(response.body);
}
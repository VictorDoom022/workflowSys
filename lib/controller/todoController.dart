import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/model/ToDo.dart';
import 'package:http/http.dart' as http;

Future<List<ToDo>> getTodoList() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");
  int userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/todo/getToDoByUserID';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'userID': userID.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    List<ToDo> listToDo = (jsonRes as List).map((e) => ToDo.fromJson(e)).toList();

    return listToDo;
  }
}
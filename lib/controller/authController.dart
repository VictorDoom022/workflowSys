import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/model/AuthReceiver.dart';

void login(BuildContext context, String email, String password) async {

  try{
    var dio = new Dio();

    var response = await dio.post(
        apiURL + "/login",
        data: {'email' : email, 'password' : password},
        options: Options(
            responseType: ResponseType.json,
            sendTimeout: 5000,
            headers: {
              'Accept': 'application/json',
            }
        )
    );

    if(response.statusCode == 200){
      AuthReceiver authReceiver = AuthReceiver.fromJson(response.data);

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("UserToken", authReceiver.token);
      sharedPreferences.setInt("UserID", authReceiver.user.id);
      sharedPreferences.setString("UserEmail", authReceiver.user.email);
      sharedPreferences.setString("UserName", authReceiver.user.name);
      sharedPreferences.setString("UserPosition", authReceiver.user.position);

    }else if(response.statusCode == 201){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('These credentials do not match our records.')));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Somethings went wrong. Code:' + response.statusCode.toString())));
    }
  }on DioError catch(e){
    if(e.response.statusCode == 422){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid format!')));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Somethings went wrong. Code' + e.response.statusCode.toString())));
    }
  }
}
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/model/AuthReceiver.dart';
import 'package:http/http.dart' as http;

import 'miscController.dart';

void login(BuildContext context, String email, String password) async {

  String stringUrl = apiURL + '/login';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {'email' : email, 'password' : password},
      headers: {
        'Accept': 'application/json',
      }
  );

  if(response.statusCode == 200){
    AuthReceiver authReceiver = AuthReceiver.fromJson(jsonDecode(response.body));

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("UserToken", authReceiver.token);
    sharedPreferences.setInt("UserID", authReceiver.user.id);
    sharedPreferences.setString("UserEmail", authReceiver.user.email);
    sharedPreferences.setString("UserName", authReceiver.user.name);
    sharedPreferences.setString("UserPosition", authReceiver.user.position);

    if(authReceiver.user.position == "admin"){
      Navigator.pushReplacementNamed(context, '/adminHome');
    }else{
      // Navigate to user home page
    }

  }else if(response.statusCode == 201){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('These credentials do not match our records.')));
  }else if(response.statusCode == 422){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input/credentials')));
  }else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Somethings went wrong. Code:' + response.statusCode.toString())));
  }
}

void logout(BuildContext context) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");

  String stringUrl = apiURL + '/logout';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization' : 'Bearer ' + token
    }
  );

  if(response.statusCode == 200){
    sharedPreferences.clear();
    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, '/login');
  }else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Somethings went wrong. Code' + response.statusCode.toString())));
  }

  String messageText = convertResponseMessage(response.body);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messageText)));
}
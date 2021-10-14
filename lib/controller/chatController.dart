import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:http/http.dart' as http;
import 'package:workflow_sys/model/Chat.dart';

Future<List<Chat>> getChatData(int receiverUserID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");
  int userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/chat/getUserChat';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'senderUserID' : userID.toString(),
        'receiverUserID': receiverUserID.toString()
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );

  List<Chat> chatList = [];
  if(response.statusCode == 200){
    var jsonRes = jsonDecode(response.body);
    chatList = (jsonRes as List).map((e) => Chat.fromJson(e)).toList();

    return chatList;
  }else{
    return chatList;
  }
}

Future<void> sendChatMessage(int receiverUserID, String chatMessage) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("UserToken");
  int userID = sharedPreferences.getInt("UserID");

  String stringUrl = apiURL + '/chat/sendMessage';
  Uri url = Uri.parse(stringUrl);
  var response = await http.post(
      url,
      body: {
        'senderUserID' : userID.toString(),
        'receiverUserID': receiverUserID.toString(),
        'chatMessage' : chatMessage,
      },
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ' + token
      }
  );
}

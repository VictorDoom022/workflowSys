import 'dart:convert';

String convertResponseMessage(String responseBody){
  Map<dynamic, dynamic> responseMap = jsonDecode(responseBody);

  return responseMap['message'];
}
import 'dart:convert';

import 'package:intl/intl.dart';

String convertResponseMessage(String responseBody){
  Map<dynamic, dynamic> responseMap = jsonDecode(responseBody);

  return responseMap['message'];
}

String convertBackendDateTime(String dbDateString){
  DateTime convertedDateTime = DateTime.parse(dbDateString);
  String formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(convertedDateTime);

  return formattedDate;
}

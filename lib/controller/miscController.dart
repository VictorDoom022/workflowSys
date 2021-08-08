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

String convertBackendDateTimeToMonth(String dbDateString){
  DateTime convertedDateTime = DateTime.parse(dbDateString);
  String month = DateFormat('MMMM').format(convertedDateTime);

  return month;
}

String convertBackendDateTimeToDate(String dbDateString){
  DateTime convertedDateTime = DateTime.parse(dbDateString);
  String date = DateFormat('dd').format(convertedDateTime);

  return date;
}

DateTime convertStringToDateTime(String dateTimeString){
  DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(dateTimeString);

  return dateTime;
}

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/model/AuthReceiver.dart';

void login(String email, String password) async {
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

  AuthReceiver authReceiver = AuthReceiver.fromJson(response.data);

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("UserToken", authReceiver.token);
  sharedPreferences.setString("UserEmail", authReceiver.user.email);
  sharedPreferences.setString("UserName", authReceiver.user.name);
}
import 'package:dio/dio.dart';
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

}
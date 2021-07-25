import 'package:dio/dio.dart';
import 'package:workflow_sys/controller/setupDir.dart';

void login(String email, String password) async {
  var dio = new Dio();

  var response = await dio.post(
      apiURL + "/login",
      data: {'email' : email, 'password' : password},
      options: Options(
        sendTimeout: 5000,
        headers: {
          'Accept': 'application/json',
        }
      )
  );
  print(response.data);
}
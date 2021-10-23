import 'User.dart';
import 'UserDetail.dart';

class AuthReceiver {
  User? user;
  UserDetail? userDetail;
  String? token;

  AuthReceiver({this.user, this.userDetail, this.token});

  AuthReceiver.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userDetail = json['userDetail'] != null
        ? new UserDetail.fromJson(json['userDetail'])
        : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    if (this.userDetail != null) {
      data['userDetail'] = this.userDetail?.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}
import 'User.dart';
import 'UserDetail.dart';

class UserReceiver {
  List<User> user;
  List<UserDetail> userDetail;

  UserReceiver({this.user, this.userDetail});

  UserReceiver.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = new List<User>();
      json['user'].forEach((v) {
        user.add(new User.fromJson(v));
      });
    }
    if (json['userDetail'] != null) {
      userDetail = new List<UserDetail>();
      json['userDetail'].forEach((v) {
        userDetail.add(new UserDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.map((v) => v.toJson()).toList();
    }
    if (this.userDetail != null) {
      data['userDetail'] = this.userDetail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
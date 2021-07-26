class UserDetail {
  int userDetailId;
  String userDetailJoinedGroupID;
  String userDetailStatus;
  int userDetailAccEnable;

  UserDetail(
      {this.userDetailId, this.userDetailJoinedGroupID, this.userDetailStatus, this.userDetailAccEnable});

  UserDetail.fromJson(Map<String, dynamic> json) {
    userDetailId = json['id'];
    userDetailJoinedGroupID = json['userDetail_joinedGroupID'];
    userDetailStatus = json['userDetail_status'];
    userDetailAccEnable = json['userDetail_accEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.userDetailId;
    data['userDetail_joinedGroupID'] = this.userDetailJoinedGroupID;
    data['userDetail_status'] = this.userDetailStatus;
    data['userDetail_accEnable'] = this.userDetailAccEnable;
    return data;
  }
}
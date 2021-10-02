class UserDetail {
  int userDetailId;
  String userDetailJoinedGroupID;
  String userDetailStatus;
  int userDetailAccEnable;
  String userDetailProfilePictureDir;

  UserDetail(
      {this.userDetailId, this.userDetailJoinedGroupID, this.userDetailStatus, this.userDetailAccEnable, this.userDetailProfilePictureDir});

  UserDetail.fromJson(Map<String, dynamic> json) {
    userDetailId = json['id'];
    userDetailJoinedGroupID = json['userDetail_joinedGroupID'];
    userDetailStatus = json['userDetail_status'];
    userDetailAccEnable = json['userDetail_accEnable'];
    userDetailProfilePictureDir = json['userDetail_profilePictureDir'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.userDetailId;
    data['userDetail_joinedGroupID'] = this.userDetailJoinedGroupID;
    data['userDetail_status'] = this.userDetailStatus;
    data['userDetail_accEnable'] = this.userDetailAccEnable;
    data['userDetail_profilePictureDir'] = this.userDetailProfilePictureDir;
    return data;
  }
}
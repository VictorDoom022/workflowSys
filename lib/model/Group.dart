class Group {
  int id;
  String groupName;
  String groupAdminList;
  String groupMemberList;
  String groupBlockListID;
  String groupTeamListID;
  String groupJoinCode;
  String createdAt;
  String updatedAt;

  Group(
      {this.id,
        this.groupName,
        this.groupAdminList,
        this.groupMemberList,
        this.groupBlockListID,
        this.groupTeamListID,
        this.groupJoinCode,
        this.createdAt,
        this.updatedAt});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['group_name'];
    groupAdminList = json['group_adminList'];
    groupMemberList = json['group_memberList'];
    groupBlockListID = json['group_blockListID'];
    groupTeamListID = json['group_teamListID'];
    groupJoinCode = json['group_joinCode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_name'] = this.groupName;
    data['group_adminList'] = this.groupAdminList;
    data['group_memberList'] = this.groupMemberList;
    data['group_blockListID'] = this.groupBlockListID;
    data['group_teamListID'] = this.groupTeamListID;
    data['group_joinCode'] = this.groupJoinCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

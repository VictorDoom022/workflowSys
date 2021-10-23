class Team {
  int? id;
  String? teamName;
  String? teamGroupID;
  String? teamMemberID;
  String? teamTaskListID;
  String? createdAt;
  String? updatedAt;

  Team(
      {this.id,
        this.teamName,
        this.teamGroupID,
        this.teamMemberID,
        this.teamTaskListID,
        this.createdAt,
        this.updatedAt});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    teamGroupID = json['team_groupID'];
    teamMemberID = json['team_memberID'];
    teamTaskListID = json['team_taskListID'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_name'] = this.teamName;
    data['team_groupID'] = this.teamGroupID;
    data['team_memberID'] = this.teamMemberID;
    data['team_taskListID'] = this.teamTaskListID;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
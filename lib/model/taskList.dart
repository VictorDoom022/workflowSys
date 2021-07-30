class TaskList {
  int id;
  String taskListTeamID;
  String taskListUserID;
  String createdAt;
  String updatedAt;

  TaskList(
      {this.id,
        this.taskListTeamID,
        this.taskListUserID,
        this.createdAt,
        this.updatedAt});

  TaskList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskListTeamID = json['taskList_teamID'];
    taskListUserID = json['taskList_userID'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['taskList_teamID'] = this.taskListTeamID;
    data['taskList_userID'] = this.taskListUserID;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}